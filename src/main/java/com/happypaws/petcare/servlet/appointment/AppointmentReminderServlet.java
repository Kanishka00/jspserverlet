package com.happypaws.petcare.servlet.appointment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.service.EmailService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/appointments/reminder")
public class AppointmentReminderServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(AppointmentReminderServlet.class.getName());
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        
        try {
            // Check if user is authenticated and is staff/receptionist
            HttpSession session = req.getSession(false);
            if (session == null) {
                res.setStatus(401);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Authentication required"));
                return;
            }
            
            String authType = (String) session.getAttribute("authType");
            String staffRole = (String) session.getAttribute("staffRole");
            boolean isReceptionist = "staff".equalsIgnoreCase(authType) 
                && staffRole != null 
                && staffRole.trim().equalsIgnoreCase("receptionist");
            
            if (!isReceptionist) {
                res.setStatus(403);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Only receptionists can send reminders"));
                return;
            }
            
            // Parse request body
            @SuppressWarnings("unchecked")
            Map<String, Object> requestBody = mapper.readValue(req.getInputStream(), Map.class);
            Object appointmentIdObj = requestBody.get("appointmentId");
            
            if (appointmentIdObj == null) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "appointmentId is required"));
                return;
            }
            
            Integer appointmentId;
            try {
                appointmentId = Integer.valueOf(appointmentIdObj.toString());
            } catch (NumberFormatException e) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Invalid appointmentId format"));
                return;
            }
            
            // Get appointment details
            Appointment appointment = AppointmentDAO.findById(appointmentId);
            if (appointment == null) {
                res.setStatus(404);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Appointment not found"));
                return;
            }
            
            // Get owner details
            Owner owner = OwnerDAO.findById(appointment.getOwnerId());
            if (owner == null) {
                res.setStatus(404);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Owner not found"));
                return;
            }
            
            // Check if owner has email
            if (owner.getEmail() == null || owner.getEmail().trim().isEmpty()) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Owner has no email address"));
                return;
            }
            
            // Send reminder email
            boolean emailSent = EmailService.sendAppointmentReminder(owner, appointment);
            
            if (emailSent) {
                if (LOGGER.isLoggable(Level.INFO)) {
                    LOGGER.info(() -> "Reminder email sent for appointment ID: " + appointmentId + 
                        " to owner: " + owner.getEmail());
                }
                
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("message", "Reminder email sent successfully"));
            } else {
                res.setStatus(500);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Failed to send reminder email"));
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error sending appointment reminder", e);
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), 
                Collections.singletonMap("error", "Internal server error: " + e.getMessage()));
        }
    }
}