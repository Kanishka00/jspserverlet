<%--
    Sales Reports Dashboard
    Location: src/main/webapp/WEB-INF/views/sales/reports.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sales Reports - Happy Paws Pet Care</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'system-ui', 'sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
                    colors: {
                        brand: {
                            50: '#effaff', 100: '#d7f0ff', 200: '#b2e1ff', 300: '#84cdff', 400: '#53b2ff',
                            500: '#2f97ff', 600: '#1679e6', 700: '#0f5fba', 800: '#0f4c91', 900: '#113e75'
                        }
                    },
                    boxShadow: {
                        soft: '0 10px 30px rgba(0,0,0,.06)',
                        glow: '0 0 0 6px rgba(47,151,255,.10)'
                    }
                }
            },
            darkMode: 'class'
        }
    </script>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<!-- Include Header -->
<%@ include file="/WEB-INF/includes/header.jsp" %>

<!-- Main Content -->
<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Page Header -->
    <div class="mb-8">
        <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Sales Reports & Analytics</h1>
        <p class="text-slate-600 dark:text-slate-300 mt-1">Financial overview and inventory alerts for managers</p>
    </div>

    <!-- Sales Summary Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <!-- Today's Sales -->
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-slate-600 dark:text-slate-300">Today's Sales</p>
                    <p class="text-2xl font-bold text-slate-900 dark:text-slate-100">
                        LKR <fmt:formatNumber value="${totalSalesToday}" pattern="#,##0.00"/>
                    </p>
                </div>
                <div class="h-12 w-12 rounded-lg bg-emerald-100 text-emerald-700 grid place-items-center">
                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm3.5 6L12 10.5 8.5 8 12 5.5 15.5 8zM8.5 16L12 13.5 15.5 16 12 18.5 8.5 16z"/>
                    </svg>
                </div>
            </div>
        </div>

        <!-- Weekly Sales -->
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-slate-600 dark:text-slate-300">This Week</p>
                    <p class="text-2xl font-bold text-slate-900 dark:text-slate-100">
                        LKR <fmt:formatNumber value="${totalSalesThisWeek}" pattern="#,##0.00"/>
                    </p>
                </div>
                <div class="h-12 w-12 rounded-lg bg-blue-100 text-blue-700 grid place-items-center">
                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/>
                    </svg>
                </div>
            </div>
        </div>

        <!-- Monthly Sales -->
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-slate-600 dark:text-slate-300">This Month</p>
                    <p class="text-2xl font-bold text-slate-900 dark:text-slate-100">
                        LKR <fmt:formatNumber value="${totalSalesThisMonth}" pattern="#,##0.00"/>
                    </p>
                </div>
                <div class="h-12 w-12 rounded-lg bg-purple-100 text-purple-700 grid place-items-center">
                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/>
                    </svg>
                </div>
            </div>
        </div>
    </div>

    <!-- Two Column Layout -->
    <div class="grid lg:grid-cols-2 gap-8">
        <!-- Top Products -->
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft">
            <div class="p-6 border-b border-slate-200 dark:border-slate-800">
                <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Top Selling Products</h2>
                <p class="text-sm text-slate-600 dark:text-slate-300">Last 30 days</p>
            </div>
            <div class="p-6">
                <c:choose>
                    <c:when test="${empty topProducts.products}">
                        <p class="text-slate-500 dark:text-slate-400 text-center py-8">No sales data available</p>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-4">
                            <c:forEach var="product" items="${topProducts.products}" varStatus="status">
                                <div class="flex items-center justify-between p-3 rounded-lg bg-slate-50 dark:bg-slate-800/50">
                                    <div class="flex items-center gap-3">
                                        <div class="h-8 w-8 rounded-lg bg-brand-100 text-brand-700 grid place-items-center font-medium">
                                                ${status.index + 1}
                                        </div>
                                        <div>
                                            <p class="font-medium text-slate-900 dark:text-slate-100">${product.name}</p>
                                            <p class="text-sm text-slate-500 dark:text-slate-400">${product.totalSold} units sold</p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <p class="font-semibold text-slate-900 dark:text-slate-100">
                                            LKR <fmt:formatNumber value="${product.totalRevenue}" pattern="#,##0.00"/>
                                        </p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="space-y-6">
            <!-- Low Stock Alerts -->
            <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft">
                <div class="p-6 border-b border-slate-200 dark:border-slate-800">
                    <div class="flex items-center justify-between">
                        <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Low Stock Alerts</h2>
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                            ${fn:length(lowStockProducts)} items
                        </span>
                    </div>
                </div>
                <div class="p-6">
                    <c:choose>
                        <c:when test="${empty lowStockProducts}">
                            <div class="text-center py-6">
                                <svg class="h-12 w-12 mx-auto text-emerald-300 dark:text-emerald-600 mb-3" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/>
                                </svg>
                                <p class="text-emerald-700 dark:text-emerald-300 font-medium">All products well stocked!</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-3 max-h-64 overflow-y-auto">
                                <c:forEach var="product" items="${lowStockProducts}" end="4">
                                    <div class="flex items-center justify-between p-3 rounded-lg bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800">
                                        <div>
                                            <p class="font-medium text-slate-900 dark:text-slate-100">${product.name}</p>
                                            <p class="text-sm text-red-600 dark:text-red-400">${product.stockQty} left in stock</p>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/inventory/edit?id=${product.productId}"
                                           class="text-xs bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded-lg font-medium">
                                            Restock
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                            <c:if test="${fn:length(lowStockProducts) > 5}">
                                <div class="mt-4 text-center">
                                    <a href="${pageContext.request.contextPath}/inventory/low-stock"
                                       class="text-sm text-brand-600 hover:text-brand-700 font-medium">
                                        View all ${fn:length(lowStockProducts)} alerts →
                                    </a>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Expiring Products -->
            <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft">
                <div class="p-6 border-b border-slate-200 dark:border-slate-800">
                    <div class="flex items-center justify-between">
                        <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Expiring Soon</h2>
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800">
                            ${fn:length(expiringProducts)} items
                        </span>
                    </div>
                </div>
                <div class="p-6">
                    <c:choose>
                        <c:when test="${empty expiringProducts}">
                            <div class="text-center py-6">
                                <svg class="h-12 w-12 mx-auto text-emerald-300 dark:text-emerald-600 mb-3" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/>
                                </svg>
                                <p class="text-emerald-700 dark:text-emerald-300 font-medium">No products expiring soon!</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-3 max-h-64 overflow-y-auto">
                                <c:forEach var="product" items="${expiringProducts}" end="4">
                                    <div class="flex items-center justify-between p-3 rounded-lg bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800">
                                        <div>
                                            <p class="font-medium text-slate-900 dark:text-slate-100">${product.name}</p>
                                            <p class="text-sm text-amber-600 dark:text-amber-400">
                                                Expires: <fmt:formatDate value="${product.expiryDate}" pattern="MMM dd, yyyy"/>
                                            </p>
                                        </div>
                                        <span class="text-xs bg-amber-100 text-amber-800 px-2 py-1 rounded-full font-medium">
                                            ${product.stockQty} left
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>
                            <c:if test="${fn:length(expiringProducts) > 5}">
                                <div class="mt-4 text-center">
                                    <a href="${pageContext.request.contextPath}/inventory/expiring"
                                       class="text-sm text-brand-600 hover:text-brand-700 font-medium">
                                        View all ${fn:length(expiringProducts)} items →
                                    </a>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions Bar -->
    <div class="mt-8 bg-gradient-to-r from-brand-600 to-brand-700 rounded-xl p-6 text-white">
        <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
            <div>
                <h3 class="text-xl font-semibold">Ready to make a sale?</h3>
                <p class="text-brand-100">Record new customer purchases and manage inventory</p>
            </div>
            <div class="flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/sales/add"
                   class="inline-flex items-center px-4 py-2 rounded-lg bg-white text-brand-700 font-medium hover:bg-brand-50">
                    Record Sale
                </a>
                <a href="${pageContext.request.contextPath}/inventory/add"
                   class="inline-flex items-center px-4 py-2 rounded-lg border border-brand-300 text-white font-medium hover:bg-brand-800">
                    Add Product
                </a>
            </div>
        </div>
    </div>
</main>

<!-- Include Footer -->
<%@ include file="/WEB-INF/includes/footer.jsp" %>

</body>
</html>