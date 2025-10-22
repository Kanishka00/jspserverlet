<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Sign in — Happy Paws PetCare</title>

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
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="header.jsp" %>

<section class="max-w-md mx-auto px-4 sm:px-6 lg:px-8 py-12">
  <h1 class="font-display text-3xl font-bold tracking-tight">Welcome back</h1>
  <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Sign in to continue.</p>

  <% String err = request.getParameter("e"); String ok = request.getParameter("ok"); %>
  <% if (err != null) { %>
  <div class="mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50"><%= err %></div>
  <% } else if (ok != null) { %>
  <div class="mt-6 rounded-xl p-4 text-sm bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50"><%= ok %></div>
  <% } %>

  <form method="post" action="<%= request.getContextPath() %>/login" class="mt-6 space-y-4 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 p-5 shadow-soft">
    <input type="hidden" name="next" value="<%= request.getParameter("next")==null? "" : request.getParameter("next") %>"/>
    <div>
      <label class="block text-sm font-medium mb-1">Email</label>
      <input name="email" type="email" required class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"/>
    </div>
    <div>
      <label class="block text-sm font-medium mb-1">Password</label>
      <input name="password" type="password" required class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"/>
    </div>
    <button class="w-full inline-flex items-center justify-center px-4 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">Sign in</button>
  </form>

  <p class="mt-4 text-sm text-slate-600 dark:text-slate-300">
    New here? <a class="text-brand-700 hover:underline" href="<%= request.getContextPath() %>/views/signup.jsp">Create an owner account</a>
  </p>
</section>

<%@ include file="footer.jsp" %>
</body>
</html>
