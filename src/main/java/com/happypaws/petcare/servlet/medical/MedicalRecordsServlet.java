package com.happypaws.petcare.servlet.medical;

import com.happypaws.petcare.dao.medical.MedicalRecordDAO;
import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.dao.user.StaffDAO;
import com.happypaws.petcare.model.MedicalRecord;
import com.happypaws.petcare.model.Pet;
import com.happypaws.petcare.model.Staff;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/medical/records")
public class MedicalRecordsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Check session for admin/staff access
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Check if user is admin or staff
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("staff"))) {
            res.sendError(403, "Access denied. Admin or Staff access required.");
            return;
        }

        String action = req.getParameter("action");
        
        try {
            if ("edit".equals(action)) {
                // Load record for editing
                String recordIdStr = req.getParameter("id");
                if (recordIdStr != null) {
                    int recordId = Integer.parseInt(recordIdStr);
                    MedicalRecord record = MedicalRecordDAO.findById(recordId);
                    req.setAttribute("editRecord", record);
                }
            }
            
            // Load all medical records
            List<MedicalRecord> records = MedicalRecordDAO.getAll();
            req.setAttribute("records", records);
            
            // Load pets and staff for dropdowns
            List<Pet> pets = PetDAO.getAll();
            req.setAttribute("pets", pets);
            
            List<Staff> staffList = StaffDAO.getAll();
            req.setAttribute("staffList", staffList);
            
            RequestDispatcher rd = req.getRequestDispatcher("/views/medical-management/medical_records.jsp");
            rd.forward(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendError(500, "Unable to load medical records: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Check session for admin/staff access
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("staff"))) {
            res.sendError(403, "Access denied. Admin or Staff access required.");
            return;
        }

        String action = req.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                // Delete record
                String recordIdStr = req.getParameter("recordId");
                if (recordIdStr != null && !recordIdStr.trim().isEmpty()) {
                    int recordId = Integer.parseInt(recordIdStr.trim());
                    MedicalRecordDAO.delete(recordId);
                    req.setAttribute("success", "Medical record deleted successfully!");
                }
            } else if ("update".equals(action)) {
                // Update existing record
                updateRecord(req);
                req.setAttribute("success", "Medical record updated successfully!");
            } else {
                // Create new record
                createRecord(req);
                req.setAttribute("success", "Medical record created successfully!");
            }
            
            // Reload page
            doGet(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error processing request: " + e.getMessage());
            doGet(req, res);
        }
    }
    
    private void createRecord(HttpServletRequest req) throws Exception {
        String petUidStr = req.getParameter("petUid");
        String staffIdStr = req.getParameter("staffId");
        String visitTimeStr = req.getParameter("visitTime");
        String weightStr = req.getParameter("weightKg");
        String notes = req.getParameter("notes");
        
        // Validate required fields
        if (petUidStr == null || petUidStr.trim().isEmpty() ||
            staffIdStr == null || staffIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Pet and Staff are required fields.");
        }
        
        MedicalRecord record = new MedicalRecord();
        record.setPetUid(Integer.parseInt(petUidStr.trim()));
        record.setStaffId(Integer.parseInt(staffIdStr.trim()));
        
        // Parse visit time
        if (visitTimeStr != null && !visitTimeStr.trim().isEmpty()) {
            try {
                LocalDateTime visitTime = LocalDateTime.parse(visitTimeStr.trim(), 
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                record.setVisitTime(visitTime);
            } catch (Exception e) {
                record.setVisitTime(LocalDateTime.now());
            }
        } else {
            record.setVisitTime(LocalDateTime.now());
        }
        
        // Parse weight
        if (weightStr != null && !weightStr.trim().isEmpty()) {
            try {
                record.setWeightKg(new BigDecimal(weightStr.trim()));
            } catch (NumberFormatException e) {
                record.setWeightKg(null);
            }
        }
        
        record.setNotes(notes != null ? notes.trim() : "");
        
        MedicalRecordDAO.insert(record);
    }
    
    private void updateRecord(HttpServletRequest req) throws Exception {
        String recordIdStr = req.getParameter("recordId");
        String petUidStr = req.getParameter("petUid");
        String staffIdStr = req.getParameter("staffId");
        String visitTimeStr = req.getParameter("visitTime");
        String weightStr = req.getParameter("weightKg");
        String notes = req.getParameter("notes");
        
        // Validate required fields
        if (recordIdStr == null || recordIdStr.trim().isEmpty() ||
            petUidStr == null || petUidStr.trim().isEmpty() ||
            staffIdStr == null || staffIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Record ID, Pet and Staff are required fields.");
        }
        
        MedicalRecord record = new MedicalRecord();
        record.setRecordId(Integer.parseInt(recordIdStr.trim()));
        record.setPetUid(Integer.parseInt(petUidStr.trim()));
        record.setStaffId(Integer.parseInt(staffIdStr.trim()));
        
        // Parse visit time
        if (visitTimeStr != null && !visitTimeStr.trim().isEmpty()) {
            try {
                LocalDateTime visitTime = LocalDateTime.parse(visitTimeStr.trim(), 
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                record.setVisitTime(visitTime);
            } catch (Exception e) {
                record.setVisitTime(LocalDateTime.now());
            }
        } else {
            record.setVisitTime(LocalDateTime.now());
        }
        
        // Parse weight
        if (weightStr != null && !weightStr.trim().isEmpty()) {
            try {
                record.setWeightKg(new BigDecimal(weightStr.trim()));
            } catch (NumberFormatException e) {
                record.setWeightKg(null);
            }
        }
        
        record.setNotes(notes != null ? notes.trim() : "");
        
        MedicalRecordDAO.update(record);
    }
}
