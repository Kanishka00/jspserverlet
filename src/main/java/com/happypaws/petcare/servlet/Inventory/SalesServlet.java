package com.happypaws.petcare.servlet.Inventory;

import com.google.gson.Gson;
import com.happypaws.petcare.dao.inventory.ProductDAO;
import com.happypaws.petcare.dao.inventory.SaleDAO;
import com.happypaws.petcare.model.Product;
import com.happypaws.petcare.model.Sale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;

/**
 * Servlet for sales and customer purchase operations
 * Location: src/main/java/com/happypaws/servlet/SalesServlet.java
 */
@WebServlet("/sales/*")
public class SalesServlet extends HttpServlet {

    private SaleDAO saleDAO;
    private ProductDAO productDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        saleDAO = new SaleDAO();
        productDAO = new ProductDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo.substring(1) : "list";

        switch (action) {
            case "list":
                listSales(request, response);
                break;
            case "add":
                showAddSaleForm(request, response);
                break;
            case "daily":
                showDailySales(request, response);
                break;
            case "reports":
                showReports(request, response);
                break;
            case "api/products":
                getAvailableProductsAPI(request, response);
                break;
            default:
                listSales(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo.substring(1) : "";

        switch (action) {
            case "add":
                addSale(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/sales/list");
                break;
        }
    }

    /**
     * List all sales
     */
    private void listSales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Sale> sales = saleDAO.getAllSales();
            request.setAttribute("sales", sales);
            request.getRequestDispatcher("/views/inventory-management/sales/list.jsp").forward(request, response);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error loading sales: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/inventory-management/inventory_management_home.jsp");
        }
    }

    /**
     * Show add sale form
     */
    private void showAddSaleForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Product> products = productDAO.getAllProducts();
            request.setAttribute("products", products);
            request.getRequestDispatcher("/views/inventory-management/sales/add.jsp").forward(request, response);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error loading products: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/inventory-management/inventory_management_home.jsp");
        }
    }

    /**
     * Add new sale
     */
    private void addSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int staffId = Integer.parseInt(request.getParameter("staffId"));

            // Get product to calculate total price and check stock
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                request.getSession().setAttribute("errorMessage", "Product not found!");
                response.sendRedirect(request.getContextPath() + "/sales/add");
                return;
            }

            if (product.getStockQty() < quantity) {
                request.getSession().setAttribute("errorMessage",
                        "Insufficient stock! Available: " + product.getStockQty());
                response.sendRedirect(request.getContextPath() + "/sales/add");
                return;
            }

            BigDecimal totalPrice = product.getUnitPrice().multiply(new BigDecimal(quantity));
            Sale sale = new Sale();
            sale.setProductId(productId);
            sale.setQuantity(quantity);
            sale.setTotalPrice(totalPrice);
            sale.setStaffId(staffId);

            if (saleDAO.insertSale(sale)) {
                request.getSession().setAttribute("successMessage", "Sale recorded successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to record sale!");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid input data!");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error recording sale: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/sales/list");
    }

    /**
     * Show daily sales
     */
    private void showDailySales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate date = LocalDate.now();
        String dateParam = request.getParameter("date");

        if (dateParam != null && !dateParam.isEmpty()) {
            try {
                date = LocalDate.parse(dateParam);
            } catch (DateTimeParseException e) {
                request.getSession().setAttribute("errorMessage", "Invalid date format!");
            }
        }

        try {
            List<Sale> dailySales = saleDAO.getSalesByDate(date);
            BigDecimal totalSales = BigDecimal.ZERO;

            for (Sale sale : dailySales) {
                totalSales = totalSales.add(sale.getTotalPrice());
            }

            request.setAttribute("sales", dailySales);
            request.setAttribute("selectedDate", date);
            request.setAttribute("totalSales", totalSales);
            request.getRequestDispatcher("/views/inventory-management/sales/daily.jsp").forward(request, response);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error loading daily sales: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/inventory-management/inventory_management_home.jsp");
        }
    }

    /**
     * Show sales reports
     */
    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get summary data
            BigDecimal totalSalesToday = saleDAO.getTotalSalesToday();
            BigDecimal totalSalesThisWeek = saleDAO.getTotalSalesThisWeek();
            BigDecimal totalSalesThisMonth = saleDAO.getTotalSalesThisMonth();

            // Get top products - Fixed method call
            List<Map<String, Object>> topProducts = saleDAO.getTopSellingProducts();

            // Get low stock alerts
            List<Product> lowStockProducts = productDAO.getLowStockProducts(10);
            List<Product> expiringProducts = productDAO.getExpiringProducts(30);

            request.setAttribute("totalSalesToday", totalSalesToday);
            request.setAttribute("totalSalesThisWeek", totalSalesThisWeek);
            request.setAttribute("totalSalesThisMonth", totalSalesThisMonth);
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("lowStockProducts", lowStockProducts);
            request.setAttribute("expiringProducts", expiringProducts);

            request.getRequestDispatcher("/views/inventory-management/sales/reports.jsp").forward(request, response);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error loading reports: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/inventory-management/inventory_management_home.jsp");
        }
    }

    /**
     * API endpoint to get available products for sale
     */
    private void getAvailableProductsAPI(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<Product> products = productDAO.getAllProducts();

            // Filter out products with zero stock
            products.removeIf(product -> product.getStockQty() <= 0);

            String json = gson.toJson(products);
            response.getWriter().write(json);
        } catch (Exception e) {
            response.getWriter().write("{\"error\":\"Failed to load products\"}");
        }
    }
}