<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Model.AppointmentManagement.Pet" %>
<%
  String cpath = request.getContextPath();
  Pet pet = (Pet) request.getAttribute("pet");
  String today = (String) request.getAttribute("today");
  String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Request Appointment — Happy Paws</title>

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

<%@ include file="header.jsp" %>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
  <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

  <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
    <div class="flex items-center justify-between gap-4 reveal">
      <div>
        <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Request Appointment</h1>
        <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Fill in the details to request an appointment.</p>
      </div>
      <a href="<%= cpath %>/views/user_appointments.jsp"
         class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
        ← Back to Appointments
      </a>
    </div>

    <% if (error != null) { %>
    <div class="reveal mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
      <%= error %>
    </div>
    <% } %>
  </div>
</section>

<!-- FORM CARD -->
<section class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
  <div class="reveal relative">
    <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

    <div class="relative rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur">
      <form method="post" action="<%= cpath %>/appointments" class="space-y-5">

        <!-- Pet (display) -->
        <div>
          <label class="block text-sm text-slate-600 dark:text-slate-300 mb-1">Pet</label>
          <div class="px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800">
            <div class="font-medium"><%= pet.getName()!=null? pet.getName():"(Unnamed)" %></div>
            <div class="text-xs text-slate-500">
              <%= pet.getSpecies()!=null? pet.getSpecies():"Pet" %>
              <% if (pet.getBreed()!=null) { %> — <%= pet.getBreed() %><% } %>
            </div>
          </div>
        </div>

        <!-- Pet UID (disabled display + hidden field) -->
        <div>
          <label for="petUid_display" class="block text-sm text-slate-600 dark:text-slate-300 mb-1">Pet UID</label>
          <input id="petUid_display" type="text" value="<%= pet.getPetUid() %>" disabled
                 class="w-full px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800 text-slate-500">
          <input type="hidden" name="petUid" value="<%= pet.getPetUid() %>">
        </div>

        <!-- Type -->
        <div>
          <label for="type" class="block text-sm text-slate-600 dark:text-slate-300 mb-1">Appointment Type</label>
          <select id="type" name="type" required
                  class="w-full px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900">
            <option value="">Select a type</option>
            <option>Grooming</option>
            <option>Veterinary</option>
          </select>
          <p class="mt-1 text-xs text-slate-500">Veterinary: Rs 3,500 • Grooming: Rs 3,000</p>
        </div>

        <!-- Date & Time -->
        <div class="grid sm:grid-cols-2 gap-4">
          <div>
            <label for="date" class="block text-sm text-slate-600 dark:text-slate-300 mb-1">Preferred Date</label>
            <input id="date" name="date" type="date" min="<%= today %>" required
                   class="w-full px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900">
          </div>
          <div>
            <label for="time" class="block text-sm text-slate-600 dark:text-slate-300 mb-1">Preferred Time</label>
            <input id="time" name="time" type="time" required
                   class="w-full px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900">
          </div>
        </div>

        <!-- Phone -->
        <div>
          <label for="phoneNo" class="block text-sm text-slate-600 dark:text-slate-300 mb-1">Phone No</label>
          <input id="phoneNo" name="phoneNo" type="tel" required
                 placeholder="e.g., 0712345678"
                 value="<%= request.getParameter("phoneNo") != null ? request.getParameter("phoneNo") : "" %>"
                 pattern="^[+0-9][0-9\\s\\-]{6,}$"
                 title="Please enter a valid phone number"
                 class="w-full px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900">
        </div>

        <!-- Staff (optional) -->
        <div>
          <label for="staffId" class="block text-sm text-slate-600 dark:text-slate-300 mb-1">Preferred Staff (optional)</label>
          <input id="staffId" name="staffId" type="number" inputmode="numeric" placeholder="Leave blank for any"
                 class="w-full px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900">
        </div>

        <!-- Actions -->
        <div class="pt-2 flex items-center gap-3">
          <button type="submit"
                  class="inline-flex items-center px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
            Submit Request
          </button>
          <a href="<%= cpath %>/owner/pets"
             class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
            Cancel
          </a>
        </div>
      </form>
    </div>
  </div>
</section>

<%@ include file="footer.jsp" %>

<script>
  // Reveal on scroll
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>
</body>
</html>
