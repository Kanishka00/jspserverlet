package com.happypaws.petcare.dao.inventory;

import com.happypaws.petcare.model.Sale;
import com.happypaws.petcare.config.DB;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Sales operations
 * Location: src/main/java/com/happypaws/dao/SaleDAO.java
 */
public class SaleDAO {

    // SQL Queries
    private static final String SELECT_ALL_SALES =
            "SELECT s.sale_id, s.product_id, p.name as product_name, s.quantity, " +
                    "s.total_price, s.sold_at, s.staff_id, st.full_name as staff_name " +
                    "FROM sales s " +
                    "JOIN products p ON s.product_id = p.product_id " +
                    "JOIN staff st ON s.staff_id = st.staff_id " +
                    "ORDER BY s.sold_at DESC";

    private static final String INSERT_SALE =
            "INSERT INTO sales (product_id, quantity, total_price, staff_id) VALUES (?, ?, ?, ?)";

    private static final String SELECT_DAILY_SALES =
            "SELECT s.sale_id, s.product_id, p.name as product_name, s.quantity, " +
                    "s.total_price, s.sold_at, s.staff_id, st.full_name as staff_name " +
                    "FROM sales s " +
                    "JOIN products p ON s.product_id = p.product_id " +
                    "JOIN staff st ON s.staff_id = st.staff_id " +
                    "WHERE CAST(s.sold_at AS DATE) = ? " +
                    "ORDER BY s.sold_at DESC";

    private static final String SELECT_SALES_BY_DATE_RANGE =
            "SELECT s.sale_id, s.product_id, p.name as product_name, s.quantity, " +
                    "s.total_price, s.sold_at, s.staff_id, st.full_name as staff_name " +
                    "FROM sales s " +
                    "JOIN products p ON s.product_id = p.product_id " +
                    "JOIN staff st ON s.staff_id = st.staff_id " +
                    "WHERE s.sold_at BETWEEN ? AND ? " +
                    "ORDER BY s.sold_at DESC";

    private static final String SELECT_TOTAL_SALES_TODAY =
            "SELECT COALESCE(SUM(total_price), 0) as total_sales " +
                    "FROM sales WHERE CAST(sold_at AS DATE) = CAST(GETDATE() AS DATE)";

    private static final String SELECT_TOTAL_SALES_THIS_WEEK =
            "SELECT COALESCE(SUM(total_price), 0) as total_sales " +
                    "FROM sales WHERE sold_at >= DATEADD(WEEK, -1, GETDATE())";

    private static final String SELECT_TOTAL_SALES_THIS_MONTH =
            "SELECT COALESCE(SUM(total_price), 0) as total_sales " +
                    "FROM sales WHERE sold_at >= DATEADD(MONTH, -1, GETDATE())";

    private static final String SELECT_TOP_SELLING_PRODUCTS =
            "SELECT TOP 5 p.product_id, p.name as product_name, " +
                    "SUM(s.quantity) as total_quantity, SUM(s.total_price) as total_sales " +
                    "FROM sales s " +
                    "JOIN products p ON s.product_id = p.product_id " +
                    "GROUP BY p.product_id, p.name " +
                    "ORDER BY total_quantity DESC";

    private static final String SELECT_SALES_BY_STAFF =
            "SELECT st.staff_id, st.full_name, COUNT(s.sale_id) as total_sales_count, " +
                    "COALESCE(SUM(s.total_price), 0) as total_sales_amount " +
                    "FROM staff st " +
                    "LEFT JOIN sales s ON st.staff_id = s.staff_id " +
                    "GROUP BY st.staff_id, st.full_name " +
                    "ORDER BY total_sales_amount DESC";

    private static final String DELETE_SALE = "DELETE FROM sales WHERE sale_id = ?";

    private static final String SELECT_SALE_BY_ID =
            "SELECT s.sale_id, s.product_id, p.name as product_name, s.quantity, " +
                    "s.total_price, s.sold_at, s.staff_id, st.full_name as staff_name " +
                    "FROM sales s " +
                    "JOIN products p ON s.product_id = p.product_id " +
                    "JOIN staff st ON s.staff_id = st.staff_id " +
                    "WHERE s.sale_id = ?";

    /**
     * Get all sales records
     */
    public List<Sale> getAllSales() {
        List<Sale> sales = new ArrayList<>();
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_SALES)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                sales.add(mapResultSetToSale(rs));
            }
        } catch (Exception e) {
            System.err.println("Error getting all sales: " + e.getMessage());
            e.printStackTrace();
        }
        return sales;
    }

    /**
     * Insert a new sale record
     */
    public boolean insertSale(Sale sale) {
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_SALE, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, sale.getProductId());
            stmt.setInt(2, sale.getQuantity());
            stmt.setBigDecimal(3, sale.getTotalPrice());
            stmt.setInt(4, sale.getStaffId());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                // Get the generated sale_id
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    sale.setSaleId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Error inserting sale: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Get sales for a specific date
     */
    public List<Sale> getSalesByDate(LocalDate date) {
        List<Sale> sales = new ArrayList<>();
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_DAILY_SALES)) {

            stmt.setDate(1, Date.valueOf(date));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                sales.add(mapResultSetToSale(rs));
            }
        } catch (Exception e) {
            System.err.println("Error getting daily sales: " + e.getMessage());
            e.printStackTrace();
        }
        return sales;
    }

    /**
     * Get sales within a date range
     */
    public List<Sale> getSalesByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        List<Sale> sales = new ArrayList<>();
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_SALES_BY_DATE_RANGE)) {

            stmt.setTimestamp(1, Timestamp.valueOf(startDate));
            stmt.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                sales.add(mapResultSetToSale(rs));
            }
        } catch (Exception e) {
            System.err.println("Error getting sales by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return sales;
    }

    /**
     * Get total sales amount for today
     */
    public BigDecimal getTotalSalesToday() throws Exception {
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_TOTAL_SALES_TODAY)) {

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total_sales");
            }
        } catch (SQLException e) {
            System.err.println("Error getting today's total sales: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return BigDecimal.ZERO;
    }

    /**
     * Get total sales amount for this week
     */
    public BigDecimal getTotalSalesThisWeek() throws Exception {
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_TOTAL_SALES_THIS_WEEK)) {

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total_sales");
            }
        } catch (SQLException e) {
            System.err.println("Error getting this week's total sales: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return BigDecimal.ZERO;
    }

    /**
     * Get total sales amount for this month
     */
    public BigDecimal getTotalSalesThisMonth() throws Exception {
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_TOTAL_SALES_THIS_MONTH)) {

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total_sales");
            }
        } catch (SQLException e) {
            System.err.println("Error getting this month's total sales: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return BigDecimal.ZERO;
    }

    /**
     * Get top selling products
     */
    public List<Map<String, Object>> getTopSellingProducts() throws Exception {
        List<Map<String, Object>> products = new ArrayList<>();
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_TOP_SELLING_PRODUCTS)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("productId", rs.getInt("product_id"));
                product.put("productName", rs.getString("product_name"));
                product.put("totalQuantity", rs.getInt("total_quantity"));
                product.put("totalSales", rs.getBigDecimal("total_sales"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.err.println("Error getting top selling products: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return products;
    }

    /**
     * Get sales performance by staff
     */
    public List<Map<String, Object>> getSalesByStaff() throws Exception {
        List<Map<String, Object>> staffSales = new ArrayList<>();
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_SALES_BY_STAFF)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> staff = new HashMap<>();
                staff.put("staffId", rs.getInt("staff_id"));
                staff.put("staffName", rs.getString("full_name"));
                staff.put("totalSalesCount", rs.getInt("total_sales_count"));
                staff.put("totalSalesAmount", rs.getBigDecimal("total_sales_amount"));
                staffSales.add(staff);
            }
        } catch (SQLException e) {
            System.err.println("Error getting sales by staff: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return staffSales;
    }

    /**
     * Get a specific sale by ID
     */
    public Sale getSaleById(int saleId) throws Exception {
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_SALE_BY_ID)) {

            stmt.setInt(1, saleId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToSale(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting sale by ID: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return null;
    }

    /**
     * Delete a sale record
     */
    public boolean deleteSale(int saleId) throws Exception {
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_SALE)) {

            stmt.setInt(1, saleId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting sale: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Helper method to map ResultSet to Sale object
     */
    private Sale mapResultSetToSale(ResultSet rs) throws SQLException {
        Sale sale = new Sale();
        sale.setSaleId(rs.getInt("sale_id"));
        sale.setProductId(rs.getInt("product_id"));
        sale.setProductName(rs.getString("product_name"));
        sale.setQuantity(rs.getInt("quantity"));
        sale.setTotalPrice(rs.getBigDecimal("total_price"));
        sale.setSoldAt(rs.getTimestamp("sold_at").toLocalDateTime());
        sale.setStaffId(rs.getInt("staff_id"));
        sale.setStaffName(rs.getString("staff_name"));
        return sale;
    }
}