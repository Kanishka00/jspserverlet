package com.happypaws.petcare.dao.appointment;

import com.happypaws.petcare.model.Pet;
import com.happypaws.petcare.config.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for appointment-related pet operations
 * Handles pet search functionality for appointment booking
 */
public class AppointmentPetDAO {
    
    /**
     * Search pets with owner information for appointment booking
     * @param searchTerm The search term to match against pet name, owner name, or phone
     * @return List of pets with owner information
     */
    public List<Pet> searchPetsWithOwner(String searchTerm) throws Exception {
        List<Pet> pets = new ArrayList<>();
        String sql = "SELECT p.pet_id, p.pet_uid, p.owner_id, p.name, p.species, p.breed, " +
                    "o.fullName as owner_name, o.phone as owner_phone " +
                    "FROM pets p " +
                    "JOIN owners o ON p.owner_id = o.ownerId " +
                    "WHERE p.name LIKE ? OR o.fullName LIKE ? OR o.phone LIKE ? " +
                    "ORDER BY p.name";
        
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Pet pet = new Pet();
                    pet.setPetId(rs.getInt("pet_id"));
                    pet.setPetUid(rs.getString("pet_uid"));
                    pet.setOwnerId(rs.getInt("owner_id"));
                    pet.setName(rs.getString("name"));
                    pet.setSpecies(rs.getString("species"));
                    pet.setBreed(rs.getString("breed"));
                    pet.setOwnerName(rs.getString("owner_name"));
                    pet.setOwnerPhone(rs.getString("owner_phone"));
                    pets.add(pet);
                }
            }
        }
        
        return pets;
    }
}