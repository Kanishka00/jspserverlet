<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.happypaws.petcare.model.Owner" %>
<%
    String cpath = request.getContextPath();
    // Get owner info from session
    HttpSession userSession = request.getSession(false);
    String ownerName = userSession != null ? (String) userSession.getAttribute("ownerName") : "Pet Owner";
    if (ownerName == null) ownerName = "Pet Owner";
    
    // Get owner from request attribute
    Owner owner = (Owner) request.getAttribute("owner");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Profile — Happy Paws PetCare</title>
    <meta name="description" content="Manage your account information." />

    <!-- Early theme init (prevents flash of wrong theme) -->
    <script>
        (function () {
            try {
                const saved = localStorage.getItem('theme');
                const sysDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
                if (saved === 'dark' || (!saved && sysDark)) {
                    document.documentElement.classList.add('dark');
                } else {
                    document.documentElement.classList.remove('dark');
                }
            } catch (e) {}
        })();
    </script>

    <!-- Fonts + Tailwind -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter','system-ui','sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
                    colors: {
                        brand: { 50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75' }
                    },
                    boxShadow: { soft:'0 10px 30px rgba(0,0,0,.06)', glow:'0 0 0 6px rgba(47,151,255,.10)' }
                }
            },
            darkMode: 'class'
        }
    </script>
    <style>
        .bg-grid {
            background-image: radial-gradient(circle at 1px 1px, rgba(16,24,40,.08) 1px, transparent 0);
            background-size: 24px 24px;
            mask-image: radial-gradient(ellipse 70% 60% at 50% -10%, black 40%, transparent 60%);
        }
        .reveal { opacity: 0; transform: translateY(12px); transition: opacity .6s ease, transform .6s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }
        .soft-card { transition: box-shadow .2s ease, transform .08s ease; }
        .soft-card:hover { transform: translateY(-1px); box-shadow: 0 10px 30px rgba(0,0,0,.08); }
        .fade-in { opacity: 0; transform: translateY(10px); transition: opacity 0.3s ease, transform 0.3s ease; }
        .fade-in.show { opacity: 1; transform: translateY(0); }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="/views/common/header.jsp" %>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="flex items-center justify-between gap-4 reveal">
            <div>
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">My Profile</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Manage your account information and settings.</p>
            </div>
            <div class="flex items-center gap-2">
                <a href="<%= cpath %>/owner-change-password"
                   class="inline-flex items-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                    Change Password
                </a>
                <a href="<%= cpath %>/owner/dashboard"
                   class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                    Back to Dashboard
                </a>
            </div>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

    <!-- Flash Messages -->
    <%
        String message = (String) request.getAttribute("message");
        String error = (String) request.getAttribute("error");
    %>
    
    <% if (message != null && !message.isEmpty()) { %>
        <div class="reveal bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 px-4 py-3 rounded-xl mb-6 flex items-center">
            <svg class="w-5 h-5 mr-2 text-emerald-500" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
            </svg>
            <%= message %>
        </div>
    <% } %>
    
    <% if (error != null && !error.isEmpty()) { %>
        <div class="reveal bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 px-4 py-3 rounded-xl mb-6 flex items-center">
            <svg class="w-5 h-5 mr-2 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
            </svg>
            <%= error %>
        </div>
    <% } %>

    <!-- Debug: Check owner object -->
    <%
        Object ownerObj = request.getAttribute("owner");
        System.out.println("DEBUG JSP: Owner attribute exists: " + (ownerObj != null));
        if (ownerObj != null) {
            System.out.println("DEBUG JSP: Owner class: " + ownerObj.getClass().getName());
        }
    %>

    <% if (owner != null) { %>
    <div class="grid md:grid-cols-3 gap-8">
        <!-- Profile Form -->
        <div class="md:col-span-2">
            <div class="reveal soft-card bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-8">
                <h2 class="text-2xl font-bold text-slate-800 dark:text-slate-100 mb-6">Profile Information</h2>
                
                <form action="<%= cpath %>/owner-profile" method="post" class="space-y-6">
                    <div class="space-y-4">
                        <div>
                            <label for="fullName" class="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2">Full Name</label>
                            <input type="text" id="fullName" name="fullName" value="<%= owner.getFullName() != null ? owner.getFullName() : "" %>" 
                                class="w-full px-4 py-3 border border-slate-300 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-all duration-200" 
                                required>
                        </div>
                        
                        <div>
                            <label for="email" class="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2">Email Address</label>
                            <input type="email" id="email" name="email" value="<%= owner.getEmail() != null ? owner.getEmail() : "" %>" 
                                class="w-full px-4 py-3 border border-slate-300 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-all duration-200" 
                                required>
                        </div>
                        
                        <div>
                            <label for="phone" class="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2">Phone Number</label>
                            <input type="tel" id="phone" name="phone" value="<%= owner.getPhone() != null ? owner.getPhone() : "" %>" 
                                class="w-full px-4 py-3 border border-slate-300 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-all duration-200" 
                                required>
                        </div>
                    </div>
                    
                    <div class="flex space-x-4 pt-4">
                        <button type="submit" 
                            class="flex-1 bg-gradient-to-r from-brand-500 to-brand-600 text-white px-6 py-3 rounded-xl font-semibold hover:from-brand-600 hover:to-brand-700 transform hover:scale-105 transition-all duration-200 shadow-soft hover:shadow-xl">
                            Update Profile
                        </button>
                        <a href="<%= cpath %>/owner/dashboard" 
                            class="flex-1 bg-slate-500 dark:bg-slate-600 text-white px-6 py-3 rounded-xl font-semibold hover:bg-slate-600 dark:hover:bg-slate-700 transform hover:scale-105 transition-all duration-200 shadow-soft hover:shadow-xl text-center">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="space-y-6">
            <!-- Account Info Card -->
            <div class="reveal soft-card bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-6">
                <h3 class="text-lg font-bold text-slate-800 dark:text-slate-100 mb-4">Account Information</h3>
                <div class="space-y-3 text-sm">
                    <div class="flex justify-between">
                        <span class="text-slate-600 dark:text-slate-400">Member Since:</span>
                        <span class="font-semibold">
                            <% if (owner.getCreatedAt() != null) { %>
                                <%= owner.getCreatedAt().toLocalDate() %>
                            <% } else { %>
                                N/A
                            <% } %>
                        </span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-600 dark:text-slate-400">Account ID:</span>
                        <span class="font-semibold">#<%= owner.getOwnerId() %></span>
                    </div>
                </div>
            </div>
            
            <!-- Quick Navigation -->
            <div class="reveal soft-card bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-6">
                <h3 class="text-lg font-bold text-slate-800 dark:text-slate-100 mb-4">Quick Navigation</h3>
                <div class="space-y-3">
                    <a href="<%= cpath %>/owner/dashboard" 
                        class="block w-full bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 px-4 py-3 rounded-xl font-semibold hover:bg-slate-200 dark:hover:bg-slate-700 transition-all duration-200 text-center">
                        Dashboard
                    </a>
                    <a href="<%= cpath %>/owner/pets" 
                        class="block w-full bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 px-4 py-3 rounded-xl font-semibold hover:bg-slate-200 dark:hover:bg-slate-700 transition-all duration-200 text-center">
                        My Pets
                    </a>
                    <a href="<%= cpath %>/my-appointments" 
                        class="block w-full bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 px-4 py-3 rounded-xl font-semibold hover:bg-slate-200 dark:hover:bg-slate-700 transition-all duration-200 text-center">
                        My Appointments
                    </a>
                </div>
            </div>
        </div>
    </div>
    <% } else { %>
        <div class="reveal bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 text-yellow-700 dark:text-yellow-300 px-4 py-3 rounded-xl mb-6 flex items-center">
            <svg class="w-5 h-5 mr-2 text-yellow-500" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
            </svg>
            Unable to load profile information. Please try again.
        </div>
    <% } %>
</section>

<%@ include file="/views/common/footer.jsp" %>

<script>
    // Reveal on scroll
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>

</body>
</html>