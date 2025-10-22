<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create account — Happy Paws PetCare</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter','system-ui','sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
                    colors: { brand: { 50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75' } },
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
    <h1 class="font-display text-3xl font-bold tracking-tight">Create your account</h1>
    <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Connect with us</p>

    <% String e = request.getParameter("e"); %>
    <% if (e != null) { %>
    <div class="mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50"><%= e %></div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/owner-signup"
          class="mt-6 space-y-4 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 p-5 shadow-soft">
        <div>
            <label class="block text-sm font-medium mb-1">Full name</label>
            <input name="fullName" required class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"/>
        </div>
        <div>
            <label class="block text-sm font-medium mb-1">Email</label>
            <input name="email" type="email" required class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"/>
        </div>
        <div>
            <label class="block text-sm font-medium mb-1">Phone</label>
            <input name="phone" required class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"/>
        </div>
        <div>
            <label class="block text-sm font-medium mb-1">Password</label>
            <input name="password" type="password" minlength="6" required class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"/>
        </div>
        <div>
            <label class="block text-sm font-medium mb-1">Confirm password</label>
            <input name="confirm" type="password" minlength="6" required class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"/>
        </div>
        <button class="w-full inline-flex items-center justify-center px-4 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">Create account</button>
    </form>

    <p class="mt-4 text-sm text-slate-600 dark:text-slate-300">
        Already have an account? <a class="text-brand-700 hover:underline" href="<%= request.getContextPath() %>/views/login.jsp">Sign in</a>
    </p>
</section>

<%@ include file="footer.jsp" %>
</body>
</html>
