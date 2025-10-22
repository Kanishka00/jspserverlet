<%--
    Sales List View
    Location: src/main/webapp/WEB-INF/views/sales/list.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sales History - Happy Paws Pet Care</title>
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
<%@ include file="/views/common/header.jsp" %>

<!-- Main Content -->
<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Page Header -->
    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
        <div>
            <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Sales History</h1>
            <p class="text-slate-600 dark:text-slate-300 mt-1">View all customer purchase transactions</p>
        </div>
        <div class="flex flex-wrap gap-3">
            <a href="<%= request.getContextPath() %>/views/inventory-management/sales/add.jsp"
               class="inline-flex items-center justify-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                <svg class="h-4 w-4 mr-2" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12L8.1 13h7.45c.75 0 1.41-.41 1.75-1.03L21.7 4H5.21l-.94-2H1zm16 16c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>
                </svg>
                Record Sale
            </a>
            <a href="<%= request.getContextPath() %>/views/inventory-management/sales/report.jsp"
               class="inline-flex items-center justify-center px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800">
                View Reports
            </a>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-slate-600 dark:text-slate-300">Total Sales</p>
                    <p class="text-2xl font-bold text-slate-900 dark:text-slate-100">${sales.size()}</p>
                </div>
                <div class="h-12 w-12 rounded-lg bg-blue-100 text-blue-700 grid place-items-center">
                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12L8.1 13h7.45c.75 0 1.41-.41 1.75-1.03L21.7 4H5.21l-.94-2H1zm16 16c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>
                    </svg>
                </div>
            </div>
        </div>

        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-slate-600 dark:text-slate-300">Total Revenue</p>
                    <p class="text-2xl font-bold text-emerald-600">
                        LKR <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/>
                    </p>
                </div>
                <div class="h-12 w-12 rounded-lg bg-emerald-100 text-emerald-700 grid place-items-center">
                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/>
                    </svg>
                </div>
            </div>
        </div>

        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-slate-600 dark:text-slate-300">Avg. Transaction</p>
                    <p class="text-2xl font-bold text-purple-600">
                        LKR <fmt:formatNumber value="${avgTransaction}" pattern="#,##0.00"/>
                    </p>
                </div>
                <div class="h-12 w-12 rounded-lg bg-purple-100 text-purple-700 grid place-items-center">
                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
                    </svg>
                </div>
            </div>
        </div>
    </div>

    <!-- Sales Table -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Sale ID</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Date & Time</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Product</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Quantity</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Total Price</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Staff</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
                <c:choose>
                    <c:when test="${empty sales}">
                        <tr>
                            <td colspan="6" class="px-6 py-12 text-center text-slate-500 dark:text-slate-400">
                                <svg class="h-12 w-12 mx-auto mb-4 text-slate-300 dark:text-slate-600" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12L8.1 13h7.45c.75 0 1.41-.41 1.75-1.03L21.7 4H5.21l-.94-2H1zm16 16c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>
                                </svg>
                                <p class="text-lg font-medium">No sales recorded yet</p>
                                <p class="text-sm">Start by recording your first sale.</p>
                                <div class="mt-4">
                                    <a href="<%= request.getContextPath() %>/views/inventory-management/sales/add.jsp"
                                       class="inline-flex items-center px-4 py-2 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-medium">
                                        Record First Sale
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="sale" items="${sales}">
                            <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/50">
                                <td class="px-6 py-4">
                                    <span class="font-medium text-slate-900 dark:text-slate-100">#${sale.saleId}</span>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm text-slate-900 dark:text-slate-100">
                                        <fmt:formatDate value="${sale.soldAt}" pattern="MMM dd, yyyy"/>
                                    </div>
                                    <div class="text-xs text-slate-500 dark:text-slate-400">
                                        <fmt:formatDate value="${sale.soldAt}" pattern="hh:mm a"/>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="font-medium text-slate-900 dark:text-slate-100">${sale.productName}</div>
                                    <div class="text-xs text-slate-500 dark:text-slate-400">Product ID: #${sale.productId}</div>
                                </td>
                                <td class="px-6 py-4">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                            ${sale.quantity} units
                                        </span>
                                </td>
                                <td class="px-6 py-4">
                                        <span class="font-semibold text-emerald-600 dark:text-emerald-400">
                                            LKR <fmt:formatNumber value="${sale.totalPrice}" pattern="#,##0.00"/>
                                        </span>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-2">
                                        <div class="h-8 w-8 rounded-full bg-brand-100 text-brand-700 grid place-items-center text-xs font-semibold">
                                                ${sale.staffName.substring(0, 2).toUpperCase()}
                                        </div>
                                        <div>
                                            <div class="text-sm font-medium text-slate-900 dark:text-slate-100">${sale.staffName}</div>
                                            <div class="text-xs text-slate-500 dark:text-slate-400">ID: #${sale.staffId}</div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination Info (Optional - for future implementation) -->
    <c:if test="${not empty sales}">
        <div class="mt-6 flex items-center justify-between text-sm text-slate-600 dark:text-slate-300">
            <p>Showing <span class="font-medium">${sales.size()}</span> sales transactions</p>
            <div class="flex gap-2">
                <a href="<%= request.getContextPath() %>/views/inventory-management/sales/daily.jsp"
                   class="px-3 py-2 border border-slate-300 dark:border-slate-700 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800">
                    Daily View
                </a>
                <a href="<%= request.getContextPath() %>/views/inventory-management/sales/report.jsp"
                   class="px-3 py-2 border border-slate-300 dark:border-slate-700 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800">
                    View Reports
                </a>
            </div>
        </div>
    </c:if>
</main>

<!-- Include Footer -->
<%@ include file="/views/common/footer.jsp" %>

<script>
    // Calculate stats on page load
    document.addEventListener('DOMContentLoaded', function() {
        // You can add JavaScript here to calculate and display statistics dynamically
        // For now, these will be calculated in the servlet
    });
</script>

</body>
</html>