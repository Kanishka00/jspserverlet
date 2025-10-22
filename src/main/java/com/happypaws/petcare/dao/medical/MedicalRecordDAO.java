package com.happypaws.petcare.dao.medical;

import com.happypaws.petcare.model.MedicalRecord;
import com.happypaws.petcare.config.DB;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicalRecordDAO {

    private static MedicalRecord map(ResultSet rs) throws SQLException {
        MedicalRecord record = new MedicalRecord();
        record.setRecordId(rs.getInt("record_id"));
        record.setPetUid(rs.getInt("pet_uid"));
        record.setStaffId(rs.getInt("staff_id"));
        
        Timestamp visitTime = null;
        try {
            visitTime = rs.getTimestamp("visit_time");
        } catch (SQLException ignored) {}
        record.setVisitTime(visitTime != null ? visitTime.toLocalDateTime() : null);
        
        BigDecimal weight = null;
        try {
            weight = rs.getBigDecimal("weight_kg");
        } catch (SQLException ignored) {}
        record.setWeightKg(weight);
        
        String notes = null;
        try {
            notes = rs.getString("notes");
        } catch (SQLException ignored) {}
        record.setNotes(notes);
        
        // Additional display fields
        try {
            record.setPetName(rs.getString("pet_name"));
        } catch (SQLException ignored) {}
        
        try {
            record.setStaffName(rs.getString("staff_name"));
        } catch (SQLException ignored) {}
        
        try {
            record.setSpecies(rs.getString("species"));
        } catch (SQLException ignored) {}
        
        return record;
    }

    public static List<MedicalRecord> getAll() throws Exception {
        final String SQL = "SELECT mr.record_id, mr.pet_uid, mr.staff_id, mr.visit_time, " +
                          "mr.weight_kg, mr.notes, " +
                          "p.name as pet_name, p.species, " +
                          "s.name as staff_name " +
                          "FROM medical_records mr " +
                          "LEFT JOIN pets p ON mr.pet_uid = p.pet_id " +
                          "LEFT JOIN staff s ON mr.staff_id = s.staff_id " +
                          "ORDER BY mr.visit_time DESC";
        
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {
            List<MedicalRecord> list = new ArrayList<>();
            while (rs.next()) {
                list.add(map(rs));
            }
            return list;
        }
    }

    public static MedicalRecord findById(int recordId) throws Exception {
        final String SQL = "SELECT mr.record_id, mr.pet_uid, mr.staff_id, mr.visit_time, " +
                          "mr.weight_kg, mr.notes, " +
                          "p.name as pet_name, p.species, " +
                          "s.name as staff_name " +
                          "FROM medical_records mr " +
                          "LEFT JOIN pets p ON mr.pet_uid = p.pet_id " +
                          "LEFT JOIN staff s ON mr.staff_id = s.staff_id " +
                          "WHERE mr.record_id = ?";
        
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(SQL)) {
            ps.setInt(1, recordId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public static List<MedicalRecord> findByPetUid(int petUid) throws Exception {
        final String SQL = "SELECT mr.record_id, mr.pet_uid, mr.staff_id, mr.visit_time, " +
                          "mr.weight_kg, mr.notes, " +
                          "p.name as pet_name, p.species, " +
                          "s.name as staff_name " +
                          "FROM medical_records mr " +
                          "LEFT JOIN pets p ON mr.pet_uid = p.pet_id " +
                          "LEFT JOIN staff s ON mr.staff_id = s.staff_id " +
                          "WHERE mr.pet_uid = ? " +
                          "ORDER BY mr.visit_time DESC";
        
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(SQL)) {
            ps.setInt(1, petUid);
            try (ResultSet rs = ps.executeQuery()) {
                List<MedicalRecord> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(map(rs));
                }
                return list;
            }
        }
    }

    public static void insert(MedicalRecord record) throws Exception {
        final String SQL = "INSERT INTO medical_records (pet_uid, staff_id, visit_time, weight_kg, notes) " +
                          "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(SQL)) {
            ps.setInt(1, record.getPetUid());
            ps.setInt(2, record.getStaffId());
            
            if (record.getVisitTime() != null) {
                ps.setTimestamp(3, Timestamp.valueOf(record.getVisitTime()));
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }
            
            if (record.getWeightKg() != null) {
                ps.setBigDecimal(4, record.getWeightKg());
            } else {
                ps.setNull(4, Types.DECIMAL);
            }
            
            ps.setString(5, record.getNotes());
            
            ps.executeUpdate();
        }
    }

    public static void update(MedicalRecord record) throws Exception {
        final String SQL = "UPDATE medical_records " +
                          "SET pet_uid = ?, staff_id = ?, visit_time = ?, weight_kg = ?, notes = ? " +
                          "WHERE record_id = ?";
        
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(SQL)) {
            ps.setInt(1, record.getPetUid());
            ps.setInt(2, record.getStaffId());
            
            if (record.getVisitTime() != null) {
                ps.setTimestamp(3, Timestamp.valueOf(record.getVisitTime()));
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }
            
            if (record.getWeightKg() != null) {
                ps.setBigDecimal(4, record.getWeightKg());
            } else {
                ps.setNull(4, Types.DECIMAL);
            }
            
            ps.setString(5, record.getNotes());
            ps.setInt(6, record.getRecordId());
            
            ps.executeUpdate();
        }
    }

    public static void delete(int recordId) throws Exception {
        final String SQL = "DELETE FROM medical_records WHERE record_id = ?";
        
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(SQL)) {
            ps.setInt(1, recordId);
            ps.executeUpdate();
        }
    }
}
