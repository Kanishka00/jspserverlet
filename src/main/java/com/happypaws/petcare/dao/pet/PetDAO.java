package com.happypaws.petcare.dao.pet;

import com.happypaws.petcare.model.Pet;
import com.happypaws.petcare.config.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PetDAO {

    private static Pet map(ResultSet rs) throws SQLException {
        Pet p = new Pet();
        p.setPetId(rs.getInt("pet_id"));
        p.setPetUid(rs.getString("pet_uid"));
        p.setOwnerId(rs.getInt("owner_id"));
        p.setName(rs.getString("name"));
        String species = null; String breed = null; String sex = null; String micro = null;
        try { species = rs.getString("species"); } catch (SQLException ignored){}
        try { breed   = rs.getString("breed"); }   catch (SQLException ignored){}
        try { sex     = rs.getString("sex"); }     catch (SQLException ignored){}
        try { micro   = rs.getString("microchip_no"); } catch (SQLException ignored){}
        p.setSpecies(species);
        p.setBreed(breed);
        p.setSex(sex);
        p.setMicrochipNo(micro);

        Date dob = null;
        try { dob = rs.getDate("dob"); } catch (SQLException ignored){}
        p.setDob(dob != null ? dob.toLocalDate() : null);

        Timestamp cts = null;
        try { cts = rs.getTimestamp("created_at"); } catch (SQLException ignored){}
        p.setCreatedAt(cts != null ? cts.toLocalDateTime() : null);

        return p;
    }

    public static List<Pet> getAll() throws Exception {
        final String SQL = "SELECT pet_id, pet_uid, owner_id, name, species, breed, dob, sex, microchip_no, created_at FROM pets ORDER BY name ASC";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {
            List<Pet> list = new ArrayList<>();
            while (rs.next()) list.add(map(rs));
            return list;
        }
    }

    public static List<Pet> findByOwner(int ownerId) throws Exception {
        final String SQL = "SELECT pet_id, pet_uid, owner_id, name, species, breed, dob, sex, microchip_no, created_at FROM pets WHERE owner_id=? ORDER BY name ASC";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(SQL)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Pet> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    public static Pet findByUid(String petUid) throws Exception {
        final String SQL = "SELECT pet_id, pet_uid, owner_id, name, species, breed, dob, sex, microchip_no, created_at FROM pets WHERE pet_uid = ?";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(SQL)) {
            ps.setString(1, petUid);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public static void insert(Pet pet) throws Exception {
        try (Connection c = DB.getConnection()) {
            // Start transaction
            c.setAutoCommit(false);
            
            try {
                // First, insert into pet_identity table
                final String identitySQL = "INSERT INTO pet_identity (pet_uid) VALUES (?)";
                try (PreparedStatement ps1 = c.prepareStatement(identitySQL)) {
                    ps1.setString(1, pet.getPetUid());
                    ps1.executeUpdate();
                }
                
                // Then, insert into pets table
                final String petsSQL = "INSERT INTO pets (pet_uid, owner_id, name, species, breed, dob, sex, microchip_no, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps2 = c.prepareStatement(petsSQL)) {
                    ps2.setString(1, pet.getPetUid());
                    ps2.setInt(2, pet.getOwnerId());
                    ps2.setString(3, pet.getName());
                    ps2.setString(4, pet.getSpecies());
                    ps2.setString(5, pet.getBreed());
                    
                    // Handle date conversion
                    if (pet.getDob() != null) {
                        ps2.setDate(6, java.sql.Date.valueOf(pet.getDob()));
                    } else {
                        ps2.setNull(6, java.sql.Types.DATE);
                    }
                    
                    ps2.setString(7, pet.getSex());
                    ps2.setString(8, pet.getMicrochipNo());
                    
                    // Set current timestamp for created_at
                    ps2.setTimestamp(9, new Timestamp(System.currentTimeMillis()));
                    
                    ps2.executeUpdate();
                }
                
                // Commit transaction
                c.commit();
                
            } catch (Exception e) {
                // Rollback on error
                c.rollback();
                throw e;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }
}