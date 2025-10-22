package com.happypaws.petcare.servlet.appointment;

import com.happypaws.petcare.dao.appointment.AppointmentPetDAO;
import com.happypaws.petcare.model.Pet;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/api/pets/search")
public class PetSearchServlet extends HttpServlet {
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    private static final String ERROR_KEY = "error";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        
        try {
            // Check if user is staff (receptionist)
            HttpSession session = req.getSession(false);
            if (session == null) {
                res.setStatus(401);
                mapper.writeValue(res.getOutputStream(), 
                        Collections.singletonMap(ERROR_KEY, "Authentication required"));
                return;
            }

            String authType = (String) session.getAttribute("authType");
            if (!"staff".equalsIgnoreCase(authType)) {
                res.setStatus(403);
                mapper.writeValue(res.getOutputStream(), 
                        Collections.singletonMap(ERROR_KEY, "Access denied"));
                return;
            }

            String searchTerm = req.getParameter("q");
            if (searchTerm == null || searchTerm.trim().isEmpty()) {
                mapper.writeValue(res.getOutputStream(), Collections.emptyList());
                return;
            }

            // Minimum 2 characters to start search
            if (searchTerm.trim().length() < 2) {
                mapper.writeValue(res.getOutputStream(), Collections.emptyList());
                return;
            }

            AppointmentPetDAO appointmentPetDAO = new AppointmentPetDAO();
            List<Pet> pets = appointmentPetDAO.searchPetsWithOwner(searchTerm.trim());
            mapper.writeValue(res.getOutputStream(), pets);

        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap(ERROR_KEY, "Search failed: " + e.getMessage()));
        }
    }
}