<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.AppointmentManagement.Pet" %>
<%
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Pets — Happy Paws PetCare</title>

    <!-- Fonts + Tailwind (same as Appointments page) -->
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
        .reveal { opacity: 0; transform: translateY(10px); transition: opacity .5s ease, transform .5s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }
        .soft-card { transition: box-shadow .2s ease, transform .08s ease; }
        .soft-card:hover { transform: translateY(-1px); box-shadow: 0 10px 30px rgba(0,0,0,.08); }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="header.jsp" %>

<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <!-- Title / Actions -->
    <div class="flex items-center justify-between gap-4">
        <div>
            <h1 class="font-display text-2xl md:text-3xl font-bold tracking-tight">My Pets</h1>
            <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Manage your pets and book appointments.</p>
        </div>
        <div class="flex items-center gap-2">
            <a href="<%= cpath %>/owner/pets/new"
               class="inline-flex items-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                Add New Pet
            </a>
            <a href="<%= cpath %>/views/user_appointments.jsp"
               class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                Back to Appointments
            </a>
        </div>
    </div>

    <!-- Pets grid -->
    <div class="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <% if (pets != null && !pets.isEmpty()) {
            for (Pet p : pets) { %>
        <article class="reveal soft-card rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft p-5">
            <div class="flex items-start justify-between">
                <div class="min-w-0">
                    <div class="mb-1">
                        <span class="inline-flex items-center px-2 py-0.5 rounded-lg text-xs bg-slate-50 dark:bg-slate-800/50 text-slate-600 dark:text-slate-300">
                            <%= p.getSpecies()!=null? p.getSpecies() : "Pet" %>
                        </span>
                    </div>
                    <h3 class="text-lg font-semibold truncate"><%= p.getName()!=null? p.getName() : "(Unnamed)" %></h3>
                </div>
            </div>

            <dl class="mt-4 text-sm space-y-2">
                <div class="flex items-center justify-between gap-3">
                    <dt class="text-slate-500">Breed</dt>
                    <dd class="text-right truncate"><%= p.getBreed()!=null? p.getBreed():"—" %></dd>
                </div>
                <div class="flex items-center justify-between gap-3">
                    <dt class="text-slate-500">Sex</dt>
                    <dd class="text-right"><%= p.getSex()!=null? p.getSex():"—" %></dd>
                </div>
                <div class="flex items-center justify-between gap-3">
                    <dt class="text-slate-500">DOB</dt>
                    <dd class="text-right"><%= p.getDob()!=null? p.getDob():"—" %></dd>
                </div>
                <div class="flex items-center justify-between gap-3 font-mono text-xs">
                    <dt class="text-slate-500">UID</dt>
                    <dd class="text-right break-all"><%= p.getPetUid() %></dd>
                </div>
            </dl>

            <div class="mt-5 flex flex-wrap gap-2">
                <a href="<%= cpath %>/appointments/new?petUid=<%= p.getPetUid() %>"
                   class="inline-flex items-center px-3 py-1.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white">
                    Add appointment
                </a>

                <a href="<%= cpath %>/owner/pets/edit?uid=<%= p.getPetUid() %>"
                   class="inline-flex items-center px-3 py-1.5 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                    Edit
                </a>

                <button type="button" onclick="deletePet('<%= p.getPetUid() %>')"
                        class="inline-flex items-center px-3 py-1.5 rounded-xl bg-rose-600 text-white hover:bg-rose-700">
                    Delete
                </button>
            </div>
        </article>
        <% } } else { %>

        <!-- Empty state -->
        <div class="reveal col-span-full">
            <div class="rounded-2xl border-2 border-dashed border-slate-200 dark:border-slate-800 p-10 text-center bg-white dark:bg-slate-900">
                <div class="mx-auto h-12 w-12 rounded-2xl bg-brand-50 dark:bg-slate-800 flex items-center justify-center mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-brand-600" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M12 6v12m6-6H6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
                <h3 class="font-semibold">No pets yet</h3>
                <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Add your first pet to start booking appointments.</p>
                <div class="mt-4">
                    <a href="<%= cpath %>/owner/pets/new"
                       class="inline-flex items-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                        Add New Pet
                    </a>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</section>

<%@ include file="footer.jsp" %>

<script>
    // Reveal on scroll (same micro-interaction feel)
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    async function deletePet(uid){
        if(!confirm("Delete this pet? This will archive the pet UID and keep past appointments intact.")) return;
        const res = await fetch("<%= cpath %>/owner/pets/delete", {
            method:"POST",
            headers:{ "Content-Type":"application/json" },
            body: JSON.stringify({ uid })
        });
        if(res.ok){ location.reload(); }
        else {
            let msg = "Failed to delete pet";
            try { const j = await res.json(); msg = j.error || msg; } catch(e){}
            alert(msg);
        }
    }
</script>

</body>
</html>
