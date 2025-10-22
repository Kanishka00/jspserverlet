package com.happypaws.petcare.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Sale model class for tracking product sales
 * Location: src/main/java/com/happypaws/model/Sale.java
 */
public class Sale {
    private int saleId;
    private int productId;
    private String productName; // For display purposes
    private int quantity;
    private BigDecimal totalPrice;
    private LocalDateTime soldAt;
    private int staffId;
    private String staffName; // For display purposes

    // Constructors
    public Sale() {}

    public Sale(int productId, int quantity, BigDecimal totalPrice, int staffId) {
        this.productId = productId;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.staffId = staffId;
    }

    public Sale(int saleId, int productId, String productName, int quantity,
                BigDecimal totalPrice, LocalDateTime soldAt, int staffId, String staffName) {
        this.saleId = saleId;
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.soldAt = soldAt;
        this.staffId = staffId;
        this.staffName = staffName;
    }

    // Getters and Setters
    public int getSaleId() {
        return saleId;
    }

    public void setSaleId(int saleId) {
        this.saleId = saleId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public LocalDateTime getSoldAt() {
        return soldAt;
    }

    public void setSoldAt(LocalDateTime soldAt) {
        this.soldAt = soldAt;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    @Override
    public String toString() {
        return "Sale{" +
                "saleId=" + saleId +
                ", productId=" + productId +
                ", productName='" + productName + '\'' +
                ", quantity=" + quantity +
                ", totalPrice=" + totalPrice +
                ", soldAt=" + soldAt +
                ", staffId=" + staffId +
                ", staffName='" + staffName + '\'' +
                '}';
    }
}