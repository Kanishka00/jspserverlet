<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Add Model.AppointmentManagement.Appointment — Happy Paws PetCare</title>
  <meta name="description" content="Create a new booking for a pet owner." />

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

<%@ include file="header.jsp" %>

<!-- PAGE HEADER (theme-aligned hero) -->
<section class="relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
  <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

  <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
    <div class="flex items-center justify-between gap-4 reveal">
      <div>
        <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Add Appointment</h1>
        <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Create a new booking for a pet owner.</p>
      </div>
      <div class="flex items-center gap-2">
        <a href="<%= request.getContextPath() %>/"
           class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
          ← Back to dashboard
        </a>
      </div>
    </div>
  </div>
</section>

<!-- CONTENT -->
<section class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
  <!-- Flash messages -->
  <%
    String flashError = (String) request.getAttribute("error");
    String flashOk = (String) request.getAttribute("ok");
    if (flashError != null) {
  %>
  <div class="reveal mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
    <%= flashError %>
  </div>
  <% } else if (flashOk != null) { %>
  <div class="reveal mt-6 rounded-xl p-4 text-sm bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50">
    <%= flashOk %>
  </div>
  <% } %>

  <!-- Form card with halo -->
  <div class="reveal relative">
    <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>
    <form method="post" action="<%= request.getContextPath() %>/appointments"
          class="relative mt-6 grid grid-cols-1 gap-4 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur">

      <div class="grid sm:grid-cols-2 gap-4">
        <div>
          <label for="petUid" class="block text-sm font-medium mb-1">Pet UID <span class="text-rose-600">*</span></label>
          <input id="petUid" name="petUid" required
                 placeholder="e.g., 8f8a2d3c-1234-4bcd-9e0f-1a2b3c4d5e6f"
                 class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2 font-mono text-xs" />
        </div>

        <div>
          <label for="ownerId" class="block text-sm font-medium mb-1">Owner ID <span class="text-rose-600">*</span></label>
          <input id="ownerId" name="ownerId" type="number" min="1" required
                 class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
        </div>

        <div>
          <label for="staffId" class="block text-sm font-medium mb-1">Staff ID <span class="text-rose-600">*</span></label>
          <input id="staffId" name="staffId" type="number" min="1" required
                 class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
        </div>

        <div>
          <label for="type" class="block text-sm font-medium mb-1">Type <span class="text-rose-600">*</span></label>
          <select id="type" name="type" required
                  class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
            <option value="">Select type…</option>
            <option>Veterinary</option>
            <option>Grooming</option>
          </select>
        </div>
      </div>

      <div class="grid sm:grid-cols-3 gap-4">
        <div>
          <label for="date" class="block text-sm font-medium mb-1">Date <span class="text-rose-600">*</span></label>
          <input id="date" name="date" type="date" required
                 class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
        </div>
        <div>
          <label for="time" class="block text-sm font-medium mb-1">Time <span class="text-rose-600">*</span></label>
          <input id="time" name="time" type="time" required
                 class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
        </div>
        <div>
          <label for="phoneNo" class="block text-sm font-medium mb-1">Phone No</label>
          <input id="phoneNo" name="phoneNo" type="tel"
                 placeholder="e.g., 0712345678"
                 pattern="^[+0-9][0-9\s\-]{6,}$"
                 class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
        </div>

        <div>
          <label for="fee" class="block text-sm font-medium mb-1">Fee (LKR)</label>
          <input id="fee" name="fee" type="number" step="0.01" min="0"
                 class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
        </div>

        <div>
          <label for="status" class="block text-sm font-medium mb-1">Initial Status <span class="text-rose-600">*</span></label>
          <select id="status" name="status" required
                  class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
            <option value="pending" selected>Pending</option>
            <option value="confirmed">Confirmed</option>
            <option value="done">Done</option>
            <option value="cancelled">Cancelled</option>
          </select>
        </div>
      </div>

      <div class="flex items-center gap-3 pt-2">
        <button class="inline-flex items-center px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
          Save appointment
        </button>
        <a href="<%= request.getContextPath() %>/"
           class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
          Cancel
        </a>
      </div>
    </form>
  </div>
</section>

<%@ include file= "footer.jsp" %>

<script>
  // Reveal on scroll
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

  // Optional: keep header's dark toggle icon in sync if present
  (function syncThemeToggleIcon(){
    const icon = document.getElementById('themeIcon');
    const root = document.documentElement;
    if (!icon) return;
    const isDark = root.classList.contains('dark');
    icon.innerHTML = isDark
            ? '<path d="M12 3.1a1 1 0 0 1 1.1.3 9 9 0 1 0 7.5 7.5 1 1 0 0 1 1.3 1.2A11 11 0 1 1 12 2a1 1 0 0 1 0 1.1Z"/>'
            : '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>';
  })();


  (function setMinDateToday(){
    const d = new Date();
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth()+1).padStart(2,'0');
    const dd = String(d.getDate()).padStart(2,'0');
    document.getElementById('date').min = `${yyyy}-${mm}-${dd}`;
  })();
</script>

</body>
</html>
