<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create account — Happy Paws PetCare</title>
    <meta name="description" content="Create your Happy Paws account." />

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
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

<%
    // Read query params from servlet redirects
    String err = request.getParameter("e");
%>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="text-center reveal">
            <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Create your account</h1>
            <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Join Happy Paws PetCare today.</p>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-md mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    <!-- Server messages -->
    <div aria-live="polite">
        <% if (err != null) { %>
        <div class="reveal mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
            <%= err %>
        </div>
        <% } %>
    </div>

    <div class="reveal relative">
        <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

        <form method="post" action="<%= request.getContextPath() %>/owner-signup"
              class="relative mt-6 space-y-4 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur"
              id="signupForm" novalidate>
        <div>
            <label for="fullName" class="block text-sm font-medium mb-1">Full name</label>
            <input name="fullName" required 
                   minlength="2"
                   maxlength="50"
                   pattern="^[a-zA-Z\s]+$"
                   title="Full name should only contain letters and spaces"
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                   id="fullName"/>
            <!-- Full name validation error message -->
            <div id="fullNameError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>
        <div>
            <label for="email" class="block text-sm font-medium mb-1">Email</label>
            <input name="email" type="email" required 
                   pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                   title="Please enter a valid email address"
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                   id="email"/>
            <!-- Email validation error message -->
            <div id="emailError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>
        <div>
            <label for="phone" class="block text-sm font-medium mb-1">Phone</label>
            <input name="phone" required 
                   type="tel"
                   pattern="^(\+94|0)[0-9]{9}$"
                   title="Please enter a valid Sri Lankan phone number (e.g., 0712345678 or +94712345678)"
                   placeholder="0712345678"
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                   id="phone"/>
            <!-- Phone validation error message -->
            <div id="phoneError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>
        <div>
            <label for="password" class="block text-sm font-medium mb-1">Password</label>
            <input name="password" type="password" minlength="8" required 
                   pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                   title="Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character"
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                   id="password"/>
            <!-- Password validation error message -->
            <div id="passwordError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>
        <div>
            <label for="confirm" class="block text-sm font-medium mb-1">Confirm password</label>
            <input name="confirm" type="password" minlength="8" required 
                   title="Please confirm your password"
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                   id="confirm"/>
            <!-- Confirm password validation error message -->
            <div id="confirmError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>
        <button type="submit" class="w-full inline-flex items-center justify-center px-4 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">Create account</button>
    </form>

    <script>
        // SIGNUP FORM VALIDATION SCRIPT
        document.addEventListener('DOMContentLoaded', function() {
            const signupForm = document.getElementById('signupForm');
            const fullNameInput = document.getElementById('fullName');
            const emailInput = document.getElementById('email');
            const phoneInput = document.getElementById('phone');
            const passwordInput = document.getElementById('password');
            const confirmInput = document.getElementById('confirm');
            
            const fullNameError = document.getElementById('fullNameError');
            const emailError = document.getElementById('emailError');
            const phoneError = document.getElementById('phoneError');
            const passwordError = document.getElementById('passwordError');
            const confirmError = document.getElementById('confirmError');

            // Full name validation function
            function validateFullName(name) {
                const nameRegex = /^[a-zA-Z\s]+$/;
                return name.length >= 2 && name.length <= 50 && nameRegex.test(name);
            }

            // Email validation function
            function validateEmail(email) {
                const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return emailRegex.test(email);
            }

            // Phone validation function (Sri Lankan numbers)
            function validatePhone(phone) {
                const phoneRegex = /^(\+94|0)[0-9]{9}$/;
                return phoneRegex.test(phone);
            }

            // Password strength validation function
            function validatePassword(password) {
                // At least 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character
                const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                return passwordRegex.test(password);
            }

            // Real-time validation for full name
            fullNameInput.addEventListener('blur', function() {
                const name = this.value.trim();
                if (name === '') {
                    fullNameError.textContent = 'Full name is required';
                    fullNameError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (!validateFullName(name)) {
                    fullNameError.textContent = 'Full name should be 2-50 characters and contain only letters and spaces';
                    fullNameError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    fullNameError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Real-time validation for email
            emailInput.addEventListener('blur', function() {
                const email = this.value.trim();
                if (email === '') {
                    emailError.textContent = 'Email is required';
                    emailError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (!validateEmail(email)) {
                    emailError.textContent = 'Please enter a valid email address';
                    emailError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    emailError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Real-time validation for phone
            phoneInput.addEventListener('blur', function() {
                const phone = this.value.trim();
                if (phone === '') {
                    phoneError.textContent = 'Phone number is required';
                    phoneError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (!validatePhone(phone)) {
                    phoneError.textContent = 'Please enter a valid Sri Lankan phone number (e.g., 0712345678)';
                    phoneError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    phoneError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Real-time validation for password
            passwordInput.addEventListener('blur', function() {
                const password = this.value;
                if (password === '') {
                    passwordError.textContent = 'Password is required';
                    passwordError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (!validatePassword(password)) {
                    passwordError.textContent = 'Password must be at least 8 characters with uppercase, lowercase, number, and special character';
                    passwordError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    passwordError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Real-time validation for confirm password
            confirmInput.addEventListener('blur', function() {
                const confirm = this.value;
                const password = passwordInput.value;
                if (confirm === '') {
                    confirmError.textContent = 'Please confirm your password';
                    confirmError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (confirm !== password) {
                    confirmError.textContent = 'Passwords do not match';
                    confirmError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    confirmError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Form submission validation
            signupForm.addEventListener('submit', function(e) {
                let isValid = true;

                // Validate full name
                const name = fullNameInput.value.trim();
                if (!name) {
                    fullNameError.textContent = 'Full name is required';
                    fullNameError.classList.remove('hidden');
                    fullNameInput.classList.add('border-red-500');
                    isValid = false;
                } else if (!validateFullName(name)) {
                    fullNameError.textContent = 'Full name should be 2-50 characters and contain only letters and spaces';
                    fullNameError.classList.remove('hidden');
                    fullNameInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Validate email
                const email = emailInput.value.trim();
                if (!email) {
                    emailError.textContent = 'Email is required';
                    emailError.classList.remove('hidden');
                    emailInput.classList.add('border-red-500');
                    isValid = false;
                } else if (!validateEmail(email)) {
                    emailError.textContent = 'Please enter a valid email address';
                    emailError.classList.remove('hidden');
                    emailInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Validate phone
                const phone = phoneInput.value.trim();
                if (!phone) {
                    phoneError.textContent = 'Phone number is required';
                    phoneError.classList.remove('hidden');
                    phoneInput.classList.add('border-red-500');
                    isValid = false;
                } else if (!validatePhone(phone)) {
                    phoneError.textContent = 'Please enter a valid Sri Lankan phone number';
                    phoneError.classList.remove('hidden');
                    phoneInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Validate password
                const password = passwordInput.value;
                if (!password) {
                    passwordError.textContent = 'Password is required';
                    passwordError.classList.remove('hidden');
                    passwordInput.classList.add('border-red-500');
                    isValid = false;
                } else if (!validatePassword(password)) {
                    passwordError.textContent = 'Password must meet security requirements';
                    passwordError.classList.remove('hidden');
                    passwordInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Validate confirm password
                const confirm = confirmInput.value;
                if (!confirm) {
                    confirmError.textContent = 'Please confirm your password';
                    confirmError.classList.remove('hidden');
                    confirmInput.classList.add('border-red-500');
                    isValid = false;
                } else if (confirm !== password) {
                    confirmError.textContent = 'Passwords do not match';
                    confirmError.classList.remove('hidden');
                    confirmInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Prevent form submission if validation fails
                if (!isValid) {
                    e.preventDefault();
                }
            });
        });
    </script>

    <!-- Sign in link moved outside the form container -->
    <div class="reveal">
        <p class="mt-6 text-center text-sm text-slate-500 dark:text-slate-400">
            Already have an account? 
            <a href="<%= request.getContextPath() %>/login" 
               class="inline-block text-brand-600 hover:text-brand-700 font-medium underline decoration-2 underline-offset-2 hover:no-underline transition-all duration-200 px-2 py-1 rounded-md hover:bg-brand-50 dark:hover:bg-brand-900/20"
               style="cursor: pointer; z-index: 999; position: relative;">
                Sign in
            </a>
        </p>
    </div>
    </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
    // Initialize reveal animations
    document.addEventListener('DOMContentLoaded', function() {
        const observer = new IntersectionObserver(entries => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
    });
</script>

</body>
</html>
