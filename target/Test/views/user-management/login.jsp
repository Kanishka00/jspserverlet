<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Sign in — Happy Paws PetCare</title>
  <meta name="description" content="Sign in to your Happy Paws account." />

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
  String ok  = request.getParameter("ok");
  String nextParam = request.getParameter("next");
  // Preserve typed email on error so user doesn't retype
  String emailPrefill = request.getParameter("email") != null ? request.getParameter("email") : "";
%>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
  <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

  <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
    <div class="text-center reveal">
      <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Welcome back</h1>
      <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Sign in to continue to Happy Paws PetCare.</p>
    </div>
  </div>
</section>

<!-- CONTENT -->
<section class="max-w-md mx-auto px-4 sm:px-6 lg:px-8 pb-16">
  <!-- Server messages (from LoginServlet). ARIA live so screen readers announce it. -->
  <div aria-live="polite">
    <% if (err != null) { %>
    <div class="reveal mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
      <%= err %>
    </div>
    <% } else if (ok != null) { %>
    <div class="reveal mt-6 rounded-xl p-4 text-sm bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50">
      <%= ok %>
    </div>
    <% } %>
  </div>

  <div class="reveal relative">
    <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

    <form method="post" action="<%= request.getContextPath() %>/login"
          class="relative mt-6 space-y-4 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur"
          id="loginForm" novalidate>
    <input type="hidden" name="next" value="<%= nextParam == null ? "" : nextParam %>"/>

    <div>
      <label for="loginEmail" class="block text-sm font-medium mb-1">Email</label>
      <input name="email" type="email" required
             pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
             title="Please enter a valid email address"
             class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
             id="loginEmail" autocomplete="username" autofocus
             value="<%= emailPrefill %>"/>
      <div id="emailError" class="text-red-500 text-sm mt-1 hidden"></div>
    </div>

    <div>
      <label for="loginPassword" class="block text-sm font-medium mb-1">Password</label>
      <input name="password" type="password" required minlength="6"
             title="Password must be at least 6 characters long"
             class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
             id="loginPassword" autocomplete="current-password"/>
      <div id="passwordError" class="text-red-500 text-sm mt-1 hidden"></div>
    </div>

    <button type="submit"
            class="w-full inline-flex items-center justify-center px-4 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
      Sign in
    </button>
  </form>
  </div>

  <!-- Signup link moved outside the halo container -->
  <div class="reveal">
    <p class="mt-6 text-center text-sm text-slate-500 dark:text-slate-400">
      Don't have an account? 
      <a href="<%= request.getContextPath() %>/owner-signup" 
         class="inline-block text-brand-600 hover:text-brand-700 font-medium underline decoration-2 underline-offset-2 hover:no-underline transition-all duration-200 px-2 py-1 rounded-md hover:bg-brand-50 dark:hover:bg-brand-900/20"
         style="cursor: pointer; z-index: 999; position: relative;">
        Sign up
      </a>
    </p>
  </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
    // Client-side validation (doesn't replace server checks)
    document.addEventListener('DOMContentLoaded', function() {
      const form = document.getElementById('loginForm');
      const emailInput = document.getElementById('loginEmail');
      const passInput  = document.getElementById('loginPassword');
      const emailErr = document.getElementById('emailError');
      const passErr  = document.getElementById('passwordError');

      const validateEmail = (v) => /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(v);
      const validatePass  = (v) => v && v.length >= 6;

      emailInput.addEventListener('blur', () => {
        const v = emailInput.value.trim();
        if (!v) {
          emailErr.textContent = 'Email is required';
          emailErr.classList.remove('hidden'); emailInput.classList.add('border-red-500');
        } else if (!validateEmail(v)) {
          emailErr.textContent = 'Please enter a valid email address';
          emailErr.classList.remove('hidden'); emailInput.classList.add('border-red-500');
        } else {
          emailErr.classList.add('hidden'); emailInput.classList.remove('border-red-500');
        }
      });

      passInput.addEventListener('blur', () => {
        const v = passInput.value;
        if (!v) {
          passErr.textContent = 'Password is required';
          passErr.classList.remove('hidden'); passInput.classList.add('border-red-500');
        } else if (!validatePass(v)) {
          passErr.textContent = 'Password must be at least 6 characters long';
          passErr.classList.remove('hidden'); passInput.classList.add('border-red-500');
        } else {
          passErr.classList.add('hidden'); passInput.classList.remove('border-red-500');
        }
      });

      form.addEventListener('submit', (e) => {
        let ok = true;
        const vEmail = emailInput.value.trim();
        const vPass  = passInput.value;

        if (!vEmail || !validateEmail(vEmail)) {
          emailErr.textContent = !vEmail ? 'Email is required' : 'Please enter a valid email address';
          emailErr.classList.remove('hidden'); emailInput.classList.add('border-red-500');
          ok = false;
        }
        if (!vPass || !validatePass(vPass)) {
          passErr.textContent = !vPass ? 'Password is required' : 'Password must be at least 6 characters long';
          passErr.classList.remove('hidden'); passInput.classList.add('border-red-500');
          ok = false;
        }
        if (!ok) e.preventDefault();
      });

      // Reveal on scroll
      const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
      }, { threshold: 0.08 });
      document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
    });
</script>
</body>
</html>
