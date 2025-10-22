package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.service.EmailService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/pay/select")
public class PaymentSelectionServlet extends HttpServlet {
    
    // Strategy Pattern Implementation
    interface PaymentStrategy {
        void processPayment(Appointment appointment, HttpServletRequest req, HttpServletResponse res) throws Exception;
        void updateAppointment(Appointment appointment);
    }
    
    class OnlinePaymentStrategy implements PaymentStrategy {
        @Override
        public void processPayment(Appointment appointment, HttpServletRequest req, HttpServletResponse res) throws Exception {
            // Online payment processing - redirect to Stripe flow
            res.sendRedirect(req.getContextPath() + "/pay/online/start?appointmentId=" + appointment.getAppointmentId());
        }
        
        @Override
        public void updateAppointment(Appointment appointment) {
            appointment.setPaymentMethod("online");
            appointment.setPaymentStatus("unpaid");
            // Online payments will set payment reference after successful payment
        }
    }
    
    class ClinicPaymentStrategy implements PaymentStrategy {
        @Override
        public void processPayment(Appointment appointment, HttpServletRequest req, HttpServletResponse res) throws Exception {
            // Send clinic payment selection confirmation email
            try {
                com.happypaws.petcare.model.Owner owner = com.happypaws.petcare.dao.user.OwnerDAO.findById(appointment.getOwnerId());
                if (owner != null && owner.getEmail() != null && !owner.getEmail().trim().isEmpty()) {
                    // Send clinic payment confirmation email with specific template
                    com.happypaws.petcare.service.EmailService.sendClinicPaymentConfirmation(owner, appointment);
                }
            } catch (Exception emailEx) {
                // Log email error but don't fail the payment processing
                System.err.println("Failed to send clinic payment confirmation email: " + emailEx.getMessage());
            }
            
            // Clinic payment processing - forward to clinic payment confirmation page
            req.setAttribute("appt", appointment);
            javax.servlet.RequestDispatcher rd = req.getRequestDispatcher("/views/payment-management/payment_clinic.jsp");
            rd.forward(req, res);
        }
        
        @Override
        public void updateAppointment(Appointment appointment) {
            appointment.setPaymentMethod("clinic");
            appointment.setPaymentStatus("unpaid");
            appointment.setPaymentRef("CLINIC");
        }
    }
    
    class PaymentProcessor {
        private PaymentStrategy strategy;
        
        public void setStrategy(PaymentStrategy strategy) {
            this.strategy = strategy;
        }
        
        public void processPayment(Appointment appointment, HttpServletRequest req, HttpServletResponse res) throws Exception {
            if (strategy == null) {
                throw new IllegalStateException("Payment strategy not set");
            }
            
            // Update appointment using strategy
            strategy.updateAppointment(appointment);
            
            // Save to database
            AppointmentDAO.update(appointment);
            
            // Process payment using strategy
            strategy.processPayment(appointment, req, res);
        }
    }
    
    private PaymentStrategy getPaymentStrategy(String method) {
        switch (method.toLowerCase()) {
            case "online":
                return new OnlinePaymentStrategy();
            case "clinic":
                return new ClinicPaymentStrategy();
            default:
                throw new IllegalArgumentException("Unknown payment method: " + method);
        }
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String id = req.getParameter("appointmentId");
        if (id == null) { res.sendError(400, "appointmentId required"); return; }
        try {
            Appointment appt = AppointmentDAO.findById(Integer.parseInt(id));
            if (appt == null) { res.sendError(404, "Appointment not found"); return; }
            req.setAttribute("appt", appt);
            RequestDispatcher rd = req.getRequestDispatcher("/views/payment-management/payment_select.jsp");
            rd.forward(req, res);
        } catch (Exception e) {
            res.sendError(500, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String id = req.getParameter("appointmentId");
        String method = req.getParameter("method"); // 'online' | 'clinic'
        String feeStr = req.getParameter("fee");
        if (id == null || method == null) { res.sendError(400, "Missing fields"); return; }

        try {
            Appointment appt = AppointmentDAO.findById(Integer.parseInt(id));
            if (appt == null) { res.sendError(404, "Appointment not found"); return; }

            // Update fee if provided
            if (feeStr != null && !feeStr.isBlank()) {
                appt.setFee(new BigDecimal(feeStr));
            }

            // Use Strategy Pattern for payment processing
            PaymentProcessor processor = new PaymentProcessor();
            PaymentStrategy strategy = getPaymentStrategy(method);
            processor.setStrategy(strategy);
            processor.processPayment(appt, req, res);
            
        } catch (Exception e) {
            res.sendError(500, e.getMessage());
        }
    }
}



