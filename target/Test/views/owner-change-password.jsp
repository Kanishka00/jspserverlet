<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String cpath = request.getContextPath();
    // Get owner info from session
    HttpSession userSession = request.getSession(false);
    String ownerName = userSession != null ? (String) userSession.getAttribute("ownerName") : "Pet Owner";
    if (ownerName == null) ownerName = "Pet Owner";
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Change Password — Happy Paws PetCare</title>
    <meta name="description" content="Update your account password." />

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
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Change Password</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Update your account password to keep your account secure.</p>
            </div>
            <div class="flex items-center gap-2">
                <a href="<%= cpath %>/owner-profile"
                   class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                    Back to Profile
                </a>
            </div>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

    <!-- Flash Messages -->
    <c:if test="${not empty message}">
        <div class="reveal bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 px-4 py-3 rounded-xl mb-6 flex items-center">
            <svg class="w-5 h-5 mr-2 text-emerald-500" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
            </svg>
            ${message}
        </div>
    </c:if>
    
    <c:if test="${not empty success}">
        <div class="reveal bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 px-4 py-3 rounded-xl mb-6 flex items-center">
            <svg class="w-5 h-5 mr-2 text-emerald-500" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
            </svg>
            ${success}
        </div>
    </c:if>
    
    <c:if test="${not empty error}">
        <div class="reveal bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 px-4 py-3 rounded-xl mb-6 flex items-center">
            <svg class="w-5 h-5 mr-2 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
            </svg>
            ${error}
        </div>
    </c:if>

    <!-- Password Change Form -->
    <div class="reveal soft-card bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-8 mb-8">
        <h2 class="text-2xl font-bold text-slate-800 dark:text-slate-100 mb-6">Update Password</h2>
        
        <form action="<%= cpath %>/owner-change-password" method="post" class="space-y-6">
            <div class="space-y-4">
                <div>
                    <label for="currentPassword" class="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" 
                        class="w-full px-4 py-3 border border-slate-300 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-all duration-200" 
                        required>
                    <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Enter your current password to verify your identity</p>
                </div>
                
                <div>
                    <label for="newPassword" class="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" 
                        class="w-full px-4 py-3 border border-slate-300 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-all duration-200" 
                        required minlength="8">
                    <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Password must be at least 8 characters long</p>
                </div>
                
                <div>
                    <label for="confirmPassword" class="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                        class="w-full px-4 py-3 border border-slate-300 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-transparent transition-all duration-200" 
                        required minlength="8">
                    <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Re-enter your new password to confirm</p>
                </div>
            </div>
            
            <div class="flex space-x-4 pt-4">
                <button type="submit" 
                    class="flex-1 bg-gradient-to-r from-brand-500 to-brand-600 text-white px-6 py-3 rounded-xl font-semibold hover:from-brand-600 hover:to-brand-700 transform hover:scale-105 transition-all duration-200 shadow-soft hover:shadow-xl">
                    Update Password
                </button>
                <a href="<%= cpath %>/owner-profile" 
                    class="flex-1 bg-slate-500 dark:bg-slate-600 text-white px-6 py-3 rounded-xl font-semibold hover:bg-slate-600 dark:hover:bg-slate-700 transform hover:scale-105 transition-all duration-200 shadow-soft hover:shadow-xl text-center">
                    Cancel
                </a>
            </div>
        </form>
    </div>

    <!-- Security Tips -->
    <div class="reveal soft-card bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-6">
        <h3 class="text-lg font-bold text-slate-800 dark:text-slate-100 mb-4">Security Tips</h3>
        <div class="grid md:grid-cols-2 gap-4 text-sm">
            <div class="flex items-start space-x-3">
                <div class="w-2 h-2 bg-brand-500 rounded-full mt-2 flex-shrink-0"></div>
                <p class="text-slate-600 dark:text-slate-400">Use a unique password that you don't use elsewhere</p>
            </div>
            <div class="flex items-start space-x-3">
                <div class="w-2 h-2 bg-brand-500 rounded-full mt-2 flex-shrink-0"></div>
                <p class="text-slate-600 dark:text-slate-400">Include a mix of letters, numbers, and symbols</p>
            </div>
            <div class="flex items-start space-x-3">
                <div class="w-2 h-2 bg-brand-500 rounded-full mt-2 flex-shrink-0"></div>
                <p class="text-slate-600 dark:text-slate-400">Avoid using personal information in passwords</p>
            </div>
            <div class="flex items-start space-x-3">
                <div class="w-2 h-2 bg-brand-500 rounded-full mt-2 flex-shrink-0"></div>
                <p class="text-slate-600 dark:text-slate-400">Change your password regularly for better security</p>
            </div>
        </div>
    </div>
</section>

<%@ include file="/views/common/footer.jsp" %>

<script>
// Password confirmation validation
document.getElementById('confirmPassword').addEventListener('input', function() {
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = this.value;
    
    if (confirmPassword && newPassword !== confirmPassword) {
        this.setCustomValidity('Passwords do not match');
    } else {
        this.setCustomValidity('');
    }
});

document.getElementById('newPassword').addEventListener('input', function() {
    const confirmPassword = document.getElementById('confirmPassword');
    if (confirmPassword.value && this.value !== confirmPassword.value) {
        confirmPassword.setCustomValidity('Passwords do not match');
    } else {
        confirmPassword.setCustomValidity('');
    }
});

// Clear form if success message is shown
document.addEventListener('DOMContentLoaded', function() {
    <c:if test="${not empty success}">
        // Clear password fields after successful change
        document.getElementById('currentPassword').value = '';
        document.getElementById('newPassword').value = '';
        document.getElementById('confirmPassword').value = '';
    </c:if>
});

// Reveal on scroll
const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
}, { threshold: 0.08 });
document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>

</body>
</html>