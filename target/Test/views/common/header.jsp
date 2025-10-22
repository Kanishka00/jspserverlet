<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String authType = (String) session.getAttribute("authType");
    String staffRole = (String) session.getAttribute("staffRole");
%>
<header class="sticky top-0 z-50 backdrop-blur bg-white/80 dark:bg-slate-950/70 border-b border-slate-200/70 dark:border-slate-800">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
            <a href="<%= request.getContextPath() %>/" class="flex items-center gap-2 group" aria-label="Happy Paws home">
        <span class="inline-grid h-9 w-9 place-items-center rounded-xl bg-gradient-to-br from-brand-500 to-brand-700 text-white shadow-soft">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-5 w-5">
            <path d="M7.5 7.5a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm6-1a2.2 2.2 0 1 1-4.4 0 2.2 2.2 0 0 1 4.4 0Zm7 3a2 2 0 1 1-4 0 2 2 0 0 1 4 0ZM6 14.5c0-2.3 2.6-3.7 6-3.7s6 1.4 6 3.7c0 2-2.7 4-6 4s-6-2-6-4Z"/>
          </svg>
        </span>
                <span class="font-display text-xl leading-tight tracking-tight">Happy Paws <span class="text-brand-700">PetCare</span></span>
            </a>
            <nav class="hidden md:flex items-center gap-8 text-sm">
                <a href="<%= request.getContextPath() %>/#features" class="hover:text-brand-700">Features</a>
                <a href="<%= request.getContextPath() %>/#services" class="hover:text-brand-700">Services</a>
                <a href="<%= request.getContextPath() %>/#stats" class="hover:text-brand-700">Stats</a>
                <a href="<%= request.getContextPath() %>/#reviews" class="hover:text-brand-700">Reviews</a>
                <a href="<%= request.getContextPath() %>/#contact" class="hover:text-brand-700">Contact</a>

                <% if (authType == null) { %>
                <a href="<%= request.getContextPath() %>/views/user-management/login.jsp" class="hover:text-brand-700">Login</a>
                <% } else if ("owner".equals(authType)) { %>
                <a href="<%= request.getContextPath() %>/owner/dashboard" class="hover:text-brand-700">Dashboard</a>
                <form method="post" action="<%= request.getContextPath() %>/logout">
                    <button class="hover:text-brand-700">Logout</button>
                </form>
                <% } else { %>
                <%
                    // Determine dashboard URL based on staff role
                    String dashboardUrl = "/views/appointment-management/receptionist-dashboard.jsp"; // default
                    if ("pharmacist".equals(staffRole)) {
                        dashboardUrl = "/views/inventory-management/inventory_management_home.jsp";
                    } else if ("receptionist".equals(staffRole)) {
                        dashboardUrl = "/views/appointment-management/receptionist-dashboard.jsp";
                    } else if ("admin".equals(staffRole)) {
                        dashboardUrl = "/views/user-management/admin.jsp";
                    }
                    // Add more roles as needed (vet, lab-tech, etc.)
                %>
                <a href="<%= request.getContextPath() %><%= dashboardUrl %>" class="hover:text-brand-700">Dashboard</a>
                <form method="post" action="<%= request.getContextPath() %>/logout">
                    <button class="hover:text-brand-700">Logout</button>
                </form>
                <% } %>
            </nav>
            <div class="flex items-center gap-3">
                <button id="themeToggle" class="p-2 rounded-lg border border-slate-200 dark:border-slate-800 hover:shadow-soft" aria-label="Toggle dark mode">
                    <svg id="themeIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                         class="h-5 w-5 fill-slate-700 dark:fill-slate-200">
                        <path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>
                    </svg>
                </button>
                <button id="menuBtn" class="md:hidden p-2 rounded-lg border border-slate-200 dark:border-slate-800" aria-label="Open menu">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                         class="h-6 w-6 fill-slate-700 dark:fill-slate-200"><path d="M4 6h16v2H4zm0 5h16v2H4zm0 5h16v2H4z"/></svg>
                </button>
            </div>
        </div>
    </div>
    <div id="mobileNav" class="md:hidden hidden border-t border-slate-200 dark:border-slate-800 bg-white/90 dark:bg-slate-950/90 backdrop-blur">
        <div class="max-w-7xl mx-auto px-4 py-3 grid gap-2 text-sm">
            <a href="<%= request.getContextPath() %>/#features" class="py-2">Features</a>
            <a href="<%= request.getContextPath() %>/#services" class="py-2">Services</a>
            <a href="<%= request.getContextPath() %>/#stats" class="py-2">Stats</a>
            <a href="<%= request.getContextPath() %>/#reviews" class="py-2">Reviews</a>
            <a href="<%= request.getContextPath() %>/#contact" class="py-2">Contact</a>
            <a href="<%= request.getContextPath() %>/#booking" class="mt-2 inline-flex items-center justify-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium">Book now</a>
        </div>
    </div>
</header>

<script>
    // Dark mode persistence
    (function(){
        const root = document.documentElement;
        const saved = localStorage.getItem('theme');
        if (saved === 'dark') root.classList.add('dark');
        document.getElementById('themeToggle')?.addEventListener('click', ()=>{
            root.classList.toggle('dark');
            const isDark = root.classList.contains('dark');
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
            document.getElementById('themeIcon').innerHTML = isDark
                ? '<path d="M12 3.1a1 1 0 0 1 1.1.3 9 9 0 1 0 7.5 7.5 1 1 0 0 1 1.3 1.2A11 11 0 1 1 12 2a1 1 0 0 1 0 1.1Z"/>'
                : '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>';
        });
        document.getElementById('menuBtn')?.addEventListener('click', ()=>{
            document.getElementById('mobileNav')?.classList.toggle('hidden');
        });
    })();
</script>
