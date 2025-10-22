<%--
    Add Sale Form View
    Location: src/main/webapp/WEB-INF/views/sales/add.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Record Sale - Happy Paws Pet Care</title>
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
<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Page Header -->
    <div class="mb-8">
        <nav class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300 mb-4">
            <a href="${pageContext.request.contextPath}/sales/list" class="hover:text-brand-600">Sales</a>
            <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor">
                <path d="M8.59 16.59L13.17 12L8.59 7.41L10 6L16 12L10 18L8.59 16.59Z"/>
            </svg>
            <span class="text-slate-900 dark:text-slate-100">Record Sale</span>
        </nav>
        <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Record New Sale</h1>
        <p class="text-slate-600 dark:text-slate-300 mt-1">Process a customer purchase transaction</p>
    </div>

    <!-- Sale Form -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft">
        <div class="p-6 border-b border-slate-200 dark:border-slate-800">
            <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Transaction Details</h2>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/sales/add" id="saleForm" class="p-6 space-y-6">
            <div class="grid md:grid-cols-2 gap-6">
                <!-- Product Selection -->
                <div class="md:col-span-2">
                    <label for="productId" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Select Product <span class="text-red-500">*</span>
                    </label>
                    <select id="productId" name="productId" required onchange="updateProductInfo()"
                            class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500">
                        <option value="">-- Select a product --</option>
                        <c:forEach var="product" items="${products}">
                            <option value="${product.productId}"
                                    data-price="${product.unitPrice}"
                                    data-stock="${product.stockQty}"
                                    data-name="${product.name}">
                                    ${product.name} - LKR <fmt:formatNumber value="${product.unitPrice}" pattern="#,##0.00"/>
                                (Stock: ${product.stockQty})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Product Info Card -->
                <div id="productInfo" class="md:col-span-2 hidden p-4 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg">
                    <div class="grid grid-cols-3 gap-4 text-sm">
                        <div>
                            <p class="text-blue-600 dark:text-blue-400 font-medium">Product</p>
                            <p class="text-blue-900 dark:text-blue-100" id="productName">-</p>
                        </div>
                        <div>
                            <p class="text-blue-600 dark:text-blue-400 font-medium">Unit Price</p>
                            <p class="text-blue-900 dark:text-blue-100 font-semibold" id="productPrice">LKR 0.00</p>
                        </div>
                        <div>
                            <p class="text-blue-600 dark:text-blue-400 font-medium">Available Stock</p>
                            <p class="text-blue-900 dark:text-blue-100 font-semibold" id="productStock">0 units</p>
                        </div>
                    </div>
                </div>

                <!-- Quantity -->
                <div>
                    <label for="quantity" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Quantity <span class="text-red-500">*</span>
                    </label>
                    <input type="number" id="quantity" name="quantity" required min="1" value="1"
                           oninput="calculateTotal()"
                           class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500"
                           placeholder="Enter quantity">
                    <p id="stockWarning" class="mt-1 text-xs text-red-600 hidden">Insufficient stock!</p>
                </div>

                <!-- Staff Selection -->
                <div>
                    <label for="staffId" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Staff Member <span class="text-red-500">*</span>
                    </label>
                    <select id="staffId" name="staffId" required
                            class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500">
                        <option value="">-- Select staff --</option>
                        <option value="4">Ishara Gunasekara (Pharmacist)</option>
                        <option value="5">Maya de Silva (Manager)</option>
                        <option value="2">Rashmi Silva (Receptionist)</option>
                    </select>
                    <p class="mt-1 text-xs text-slate-500 dark:text-slate-400">Select the staff member processing this sale</p>
                </div>

                <!-- Total Price Display -->
                <div class="md:col-span-2 p-6 bg-gradient-to-r from-emerald-50 to-emerald-100 dark:from-emerald-900/20 dark:to-emerald-800/20 border border-emerald-200 dark:border-emerald-800 rounded-lg">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-emerald-700 dark:text-emerald-300 text-sm font-medium">Total Amount</p>
                            <p class="text-emerald-900 dark:text-emerald-100 text-3xl font-bold" id="totalPrice">LKR 0.00</p>
                        </div>
                        <div class="h-16 w-16 rounded-full bg-emerald-600 text-white grid place-items-center">
                            <svg class="h-8 w-8" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Form Actions -->
            <div class="flex flex-col sm:flex-row justify-end gap-4">
                <a href="${pageContext.request.contextPath}/sales/list"
                   class="inline-flex items-center px-4 py-2 border border-slate-300 dark:border-slate-700 rounded-lg text-sm font-medium text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800">
                    Cancel
                </a>
                <button type="submit"
                        class="inline-flex items-center px-4 py-2 bg-brand-600 text-white rounded-lg text-sm font-medium hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500 disabled:opacity-50"
                        id="submitButton" disabled>
                    Record Sale
                </button>
            </div>
        </form>
    </div>

    <!-- Error/Success Messages -->
    <c:if test="${not empty errorMessage}">
        <div class="mt-4 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg text-red-700 dark:text-red-300">
            <p>${errorMessage}</p>
        </div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="mt-4 p-4 bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-lg text-green-700 dark:text-green-300">
            <p>${successMessage}</p>
        </div>
    </c:if>
</main>

<!-- Include Footer -->
<%@ include file="/WEB-INF/includes/footer.jsp" %>

<script>
    // Update product info when selected
    function updateProductInfo() {
        const select = document.getElementById('productId');
        const productInfo = document.getElementById('productInfo');
        const productName = document.getElementById('productName');
        const productPrice = document.getElementById('productPrice');
        const productStock = document.getElementById('productStock');
        const quantity = document.getElementById('quantity');
        const stockWarning = document.getElementById('stockWarning');
        const submitButton = document.getElementById('submitButton');

        if (select.value) {
            const selectedOption = select.options[select.selectedIndex];
            productName.textContent = selectedOption.getAttribute('data-name');
            productPrice.textContent = `LKR ${parseFloat(selectedOption.getAttribute('data-price')).toFixed(2)}`;
            productStock.textContent = `${selectedOption.getAttribute('data-stock')} units`;
            productInfo.classList.remove('hidden');
            quantity.max = selectedOption.getAttribute('data-stock');
            checkStock();
            calculateTotal();
        } else {
            productInfo.classList.add('hidden');
            productName.textContent = '-';
            productPrice.textContent = 'LKR 0.00';
            productStock.textContent = '0 units';
            quantity.max = '';
            stockWarning.classList.add('hidden');
            submitButton.disabled = true;
        }
    }

    // Check stock availability
    function checkStock() {
        const select = document.getElementById('productId');
        const quantity = document.getElementById('quantity');
        const stockWarning = document.getElementById('stockWarning');
        const submitButton = document.getElementById('submitButton');

        if (select.value) {
            const maxStock = parseInt(select.options[select.selectedIndex].getAttribute('data-stock'));
            if (parseInt(quantity.value) > maxStock) {
                stockWarning.classList.remove('hidden');
                submitButton.disabled = true;
            } else {
                stockWarning.classList.add('hidden');
                submitButton.disabled = !select.value || !quantity.value || !document.getElementById('staffId').value;
            }
        }
    }

    // Calculate total price
    function calculateTotal() {
        const select = document.getElementById('productId');
        const quantity = document.getElementById('quantity');
        const totalPrice = document.getElementById('totalPrice');
        const submitButton = document.getElementById('submitButton');

        if (select.value && quantity.value) {
            const unitPrice = parseFloat(select.options[select.selectedIndex].getAttribute('data-price'));
            const total = unitPrice * parseInt(quantity.value);
            totalPrice.textContent = `LKR ${total.toFixed(2)}`;
            checkStock();
        } else {
            totalPrice.textContent = 'LKR 0.00';
            submitButton.disabled = true;
        }
    }

    // Form validation and submission
    document.getElementById('saleForm').addEventListener('submit', function(e) {
        const select = document.getElementById('productId');
        const quantity = document.getElementById('quantity');
        const staffId = document.getElementById('staffId');
        const submitButton = document.getElementById('submitButton');

        if (!select.value || !quantity.value || !staffId.value) {
            e.preventDefault();
            alert('Please fill all required fields.');
            submitButton.disabled = true;
            return;
        }

        const maxStock = parseInt(select.options[select.selectedIndex].getAttribute('data-stock'));
        if (parseInt(quantity.value) > maxStock) {
            e.preventDefault();
            alert('Quantity exceeds available stock.');
            submitButton.disabled = true;
            return;
        }

        submitButton.disabled = true; // Disable during submission
    });

    // Initial setup
    document.getElementById('quantity').addEventListener('input', function() {
        checkStock();
        calculateTotal();
    });

    document.getElementById('staffId').addEventListener('change', function() {
        const submitButton = document.getElementById('submitButton');
        submitButton.disabled = !this.value || !document.getElementById('productId').value || !document.getElementById('quantity').value;
    });
</script>
</body>
</html>