<%--
    Daily Sales View
    Location: src/main/webapp/views/inventory-management/sales/daily.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Daily Sales - Happy Paws Pet Care</title>
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

<!-- MAIN CONTENT -->
<section class="py-16">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-slate-900 dark:text-slate-100">Daily Sales Report</h1>
            <p class="text-slate-600 dark:text-slate-400 mt-2">View sales for <fmt:formatDate value="${requestScope.selectedDate}" pattern="MMMM dd, yyyy" /></p>
        </div>

        <!-- Back to Dashboard -->
        <div class="mb-6">
            <a href="${pageContext.request.contextPath}/views/inventory-management/inventory_management_home.jsp" 
               class="inline-flex items-center px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg transition-colors">
                ← Back to Dashboard
            </a>
        </div>

        <!-- Daily Summary -->
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 mb-8">
            <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100 mb-4">Summary</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="text-center">
                    <p class="text-2xl font-bold text-emerald-600">${salesList.size()}</p>
                    <p class="text-sm text-slate-600 dark:text-slate-400">Total Sales</p>
                </div>
                <div class="text-center">
                    <p class="text-2xl font-bold text-blue-600">
                        <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="LKR " />
                    </p>
                    <p class="text-sm text-slate-600 dark:text-slate-400">Total Revenue</p>
                </div>
                <div class="text-center">
                    <p class="text-2xl font-bold text-purple-600">
                        <fmt:formatNumber value="${averageAmount}" type="currency" currencySymbol="LKR " />
                    </p>
                    <p class="text-sm text-slate-600 dark:text-slate-400">Average Sale</p>
                </div>
            </div>
        </div>

        <!-- Sales List -->
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 overflow-hidden">
            <div class="px-6 py-4 border-b border-slate-200 dark:border-slate-800">
                <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Sales Transactions</h2>
            </div>
            
            <c:choose>
                <c:when test="${not empty salesList}">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-slate-50 dark:bg-slate-800">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Time</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Product</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Quantity</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Amount</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Staff</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white dark:bg-slate-900 divide-y divide-slate-200 dark:divide-slate-700">
                                <c:forEach var="sale" items="${salesList}">
                                    <tr class="hover:bg-slate-50 dark:hover:bg-slate-800">
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-900 dark:text-slate-100">
                                            <fmt:formatDate value="${sale.soldAt}" pattern="HH:mm:ss" />
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-900 dark:text-slate-100">
                                            ${sale.productName}
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-900 dark:text-slate-100">
                                            ${sale.quantity}
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-900 dark:text-slate-100">
                                            <fmt:formatNumber value="${sale.totalPrice}" type="currency" currencySymbol="LKR " />
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-900 dark:text-slate-100">
                                            ${sale.staffName}
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="px-6 py-12 text-center">
                        <div class="h-16 w-16 mx-auto mb-4 bg-slate-100 dark:bg-slate-800 rounded-full flex items-center justify-center">
                            <svg class="h-8 w-8 text-slate-400" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12L8.1 13h7.45c.75 0 1.41-.41 1.75-1.03L21.7 4H5.21l-.94-2H1zm16 16c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>
                            </svg>
                        </div>
                        <h3 class="text-lg font-medium text-slate-900 dark:text-slate-100 mb-2">No Sales Today</h3>
                        <p class="text-slate-500 dark:text-slate-400">No sales transactions were recorded for this date.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- Include Footer -->
<%@ include file="/views/common/footer.jsp" %>

</body>
</html>