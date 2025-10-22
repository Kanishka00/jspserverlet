<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Receptionist Dashboard — Happy Paws PetCare</title>
  <meta name="description" content="Manage bookings, reschedules, completions, and cancellations." />

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
            brand: {
              50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',
              500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75'
            }
          },
          boxShadow: { soft:'0 10px 30px rgba(0,0,0,.06)', glow:'0 0 0 6px rgba(47,151,255,.10)' }
        }
      },
      darkMode: 'class'
    }
  </script>
  <style>
    /* Match homepage visuals */
    .bg-grid {
      background-image: radial-gradient(circle at 1px 1px, rgba(16,24,40,.08) 1px, transparent 0);
      background-size: 24px 24px;
      mask-image: radial-gradient(ellipse 70% 60% at 50% -10%, black 40%, transparent 60%);
    }
    .reveal { opacity: 0; transform: translateY(12px); transition: opacity .6s ease, transform .6s ease; }
    .reveal.visible { opacity: 1; transform: translateY(0); }
    th { font-weight: 600; color: rgb(71 85 105); }      /* slate-600 */
    .dark th { color: rgb(203 213 225); }                /* slate-300 */
  </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="header.jsp" %>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
  <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

  <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
    <div class="grid md:grid-cols-2 gap-6 items-center reveal">
      <div>
        <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Receptionist Dashboard</h1>
        <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">
          Manage bookings, reschedules, mark done, and cancellations — all in one place.
        </p>
        <div class="mt-6 flex flex-wrap gap-3">
          <a href="<%= request.getContextPath() %>/views/add-appointment.jsp"
             class="inline-flex items-center justify-center px-5 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
            + Add appointment
          </a>
          <button onclick="loadAppointments()"
                  class="inline-flex items-center justify-center px-5 py-3 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
            Refresh
          </button>
        </div>
      </div>

      <!-- Quick stats -->
      <div class="reveal">
        <div class="relative mx-auto w-full max-w-xl">
          <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/25 via-brand-400/15 to-brand-600/25 blur-2xl"></div>
          <div class="relative rounded-3xl bg-white/70 dark:bg-slate-900/60 border border-slate-200/70 dark:border-slate-700 p-6 shadow-soft backdrop-blur">
            <div class="grid grid-cols-3 gap-3">
              <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center">
                <p class="text-xs text-slate-500">Upcoming</p>
                <p id="heroActive" class="text-2xl font-extrabold tabular-nums">0</p>
              </div>
              <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center">
                <p class="text-xs text-slate-500">Completed</p>
                <p id="heroCompleted" class="text-2xl font-extrabold tabular-nums">0</p>
              </div>
              <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center">
                <p class="text-xs text-slate-500">Cancelled</p>
                <p id="heroCancelled" class="text-2xl font-extrabold tabular-nums">0</p>
              </div>
            </div>
            <p class="mt-3 text-[11px] text-slate-500 dark:text-slate-400">Live counts update as you take actions below.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- MAIN -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

  <!-- Filters -->
  <div class="reveal mt-6 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft p-5">
    <h2 class="font-semibold text-base">Filters</h2>
    <div class="mt-4 grid sm:grid-cols-2 lg:grid-cols-4 gap-3">
      <input id="f_petUid" placeholder="Filter by petUid (UUID)"
             class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
      <select id="f_type"
              class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
        <option value="">All types</option>
        <option value="Veterinary">Veterinary</option>
        <option value="Grooming">Grooming</option>
      </select>
      <select id="f_status"
              class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
        <option value="">All status</option>
        <option value="pending">Pending</option>
        <option value="confirmed">Confirmed</option>
        <option value="done">Done</option>
        <option value="cancelled">Cancelled</option>
      </select>
      <div class="flex gap-2">
        <button onclick="loadAppointments(true)"
                class="flex-1 rounded-xl bg-brand-600 hover:bg-brand-700 text-white px-4 py-2 font-medium shadow-soft">
          Apply
        </button>
        <button onclick="resetFilters()" class="rounded-xl border border-slate-200 dark:border-slate-800 px-4 py-2 hover:shadow-soft">
          Reset
        </button>
      </div>
    </div>
  </div>

  <!-- Upcoming -->
  <div class="reveal mt-8">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-xl font-bold tracking-tight">Upcoming appointments</h3>
      <span id="countActive" class="text-xs text-slate-500"></span>
    </div>
    <div class="mt-3 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
      <table class="min-w-full text-sm">
        <thead class="bg-slate-50 dark:bg-slate-800/50">
        <tr>
          <th class="px-4 py-3 text-left">When</th>
          <th class="px-4 py-3 text-left">Pet UID</th>
          <th class="px-4 py-3 text-left">Owner</th>
          <th class="px-4 py-3 text-left">Type</th>
          <th class="px-4 py-3 text-left">Phone</th>
          <th class="px-4 py-3 text-left">Status</th>
          <th class="px-4 py-3 text-left">Payment</th>
          <th class="px-4 py-3 text-left">Fee</th>
          <th class="px-4 py-3 text-left">Actions</th>
        </tr>
        </thead>
        <tbody id="appointmentsBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
      </table>
    </div>
  </div>

  <!-- Completed -->
  <div class="reveal mt-10">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-xl font-bold tracking-tight">Completed appointments</h3>
      <span id="countCompleted" class="text-xs text-slate-500"></span>
    </div>
    <div class="mt-3 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
      <table class="min-w-full text-sm">
        <thead class="bg-slate-50 dark:bg-slate-800/50">
        <tr>
          <th class="px-4 py-3 text-left">ID</th>
          <th class="px-4 py-3 text-left">Pet UID</th>
          <th class="px-4 py-3 text-left">Owner</th>
          <th class="px-4 py-3 text-left">Type</th>
          <th class="px-4 py-3 text-left">Completed at</th>
        </tr>
        </thead>
        <tbody id="completedBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
      </table>
    </div>
  </div>

  <!-- Cancelled -->
  <div class="reveal mt-10">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-xl font-bold tracking-tight">Cancelled appointments</h3>
      <span id="countCanceled" class="text-xs text-slate-500"></span>
    </div>
    <div class="mt-3 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
      <table class="min-w-full text-sm">
        <thead class="bg-slate-50 dark:bg-slate-800/50">
        <tr>
          <th class="px-4 py-3 text-left">ID</th>
          <th class="px-4 py-3 text-left">Pet UID</th>
          <th class="px-4 py-3 text-left">Owner</th>
          <th class="px-4 py-3 text-left">Type</th>
          <th class="px-4 py-3 text-left">Scheduled at</th>
          <th class="px-4 py-3 text-left">Actions</th>
        </tr>
        </thead>
        <tbody id="canceledBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
      </table>
    </div>
  </div>
</section>

<%@ include file= "footer.jsp" %>

<script>
  // Reveal on scroll (same behavior as homepage)
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

  // === DARK THEME TOGGLE (same contract as homepage) ===
  (function setupThemeToggle(){
    const btn = document.getElementById('themeToggle');
    const icon = document.getElementById('themeIcon');
    const root = document.documentElement;

    function setIcon() {
      const isDark = root.classList.contains('dark');
      if (!icon) return;
      icon.innerHTML = isDark
              ? '<path d="M12 3.1a1 1 0 0 1 1.1.3 9 9 0 1 0 7.5 7.5 1 1 0 0 1 1.3 1.2A11 11 0 1 1 12 2a1 1 0 0 1 0 1.1Z"/>'
              : '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>';
    }

    // Initialize icon on load
    setIcon();

    // Wire up toggle (no error if button missing)
    btn && btn.addEventListener('click', () => {
      root.classList.toggle('dark');
      const isDark = root.classList.contains('dark');
      try { localStorage.setItem('theme', isDark ? 'dark' : 'light'); } catch (e) {}
      setIcon();
    });
  })();

  // === APP LOGIC ===
  const BASE = "<%= request.getContextPath() %>/appointments";
  const RES_PAGE = "<%= request.getContextPath() %>/views/reschedule-appointment.jsp";

  function statusPill(s) {
    const map = {
      pending:   "bg-amber-100 text-amber-700",
      confirmed: "bg-emerald-100 text-emerald-700",
      done:      "bg-slate-200 text-slate-700",
      cancelled: "bg-rose-100 text-rose-700"
    };
    const label = (s || "pending").toLowerCase();
    const cls = map[label] || "bg-slate-100 text-slate-700";
    const pretty = label.charAt(0).toUpperCase() + label.slice(1);
    return `<span class="inline-flex items-center px-2 py-0.5 rounded-lg text-xs ${cls}">${pretty}</span>`;
  }


  function rowActive(appt){
    const when = appt.scheduledAt ? new Date(appt.scheduledAt).toLocaleString() : "-";
    const payLabel = (() => {
      const method = (appt.paymentMethod || '-').toUpperCase();
      const status = (appt.paymentStatus || 'unpaid').toUpperCase();
      if (method === 'CLINIC') return 'Pay at clinic — ' + status;
      return `${method} — ${status}`;
    })();

    return `<tr>
    <td class="px-4 py-3">${when}</td>
    <td class="px-4 py-3 font-mono text-xs">${appt.petUid || "-"}</td>
    <td class="px-4 py-3">${appt.ownerId || "-"}</td>
    <td class="px-4 py-3">${appt.type || "-"}</td>
    <td class="px-4 py-3">${appt.phoneNo || "-"}</td>
    <td class="px-4 py-3">${statusPill(appt.status)}</td>
    <td class="px-4 py-3">${payLabel}</td>
    <td class="px-4 py-3">Rs${appt.fee != null ? appt.fee : "-"}</td>
    <td class="px-4 py-3">
      <div class="flex flex-wrap gap-2">
        <button class="px-3 py-1 rounded-lg border hover:shadow-soft"
          onclick="confirmIfEligible(${appt.appointmentId}, '${(appt.paymentMethod||'')}', '${(appt.paymentStatus||'')}' )">Confirm</button>
        <a class="px-3 py-1 rounded-lg border hover:shadow-soft inline-flex items-center"
           href="${RES_PAGE}?id=${appt.appointmentId}">
           Reschedule
        </a>
        <button class="px-3 py-1 rounded-lg border hover:shadow-soft"
          onclick="updateStatus(${appt.appointmentId}, 'done')">Mark Done</button>
        <button class="px-3 py-1 rounded-lg bg-rose-600 text-white hover:bg-rose-700"
          onclick="updateStatus(${appt.appointmentId}, 'cancelled')">Cancel</button>
      </div>
    </td>
  </tr>`;

  }

  function confirmIfEligible(id, method, payStatus){
    const ok = (String(method).toLowerCase()==='clinic') || (String(payStatus).toLowerCase()==='paid');
    if(!ok){ alert("Cannot confirm until paid or pay-at-clinic is selected."); return; }
    updateStatus(id, 'confirmed');
  }

  function rowCompleted(appt){
    const when = appt.scheduledAt ? new Date(appt.scheduledAt).toLocaleString() : "-";
    return `<tr>
        <td class="px-4 py-3">${appt.appointmentId}</td>
        <td class="px-4 py-3 font-mono text-xs">${appt.petUid || "-"}</td>
        <td class="px-4 py-3">${appt.ownerId || "-"}</td>
        <td class="px-4 py-3">${appt.type || "-"}</td>
        <td class="px-4 py-3">${when}</td>
    </tr>`;
  }

  function rowCanceled(appt){
    const when = appt.scheduledAt ? new Date(appt.scheduledAt).toLocaleString() : "-";
    return `<tr>
        <td class="px-4 py-3">${appt.appointmentId}</td>
        <td class="px-4 py-3 font-mono text-xs">${appt.petUid || "-"}</td>
        <td class="px-4 py-3">${appt.ownerId || "-"}</td>
        <td class="px-4 py-3">${appt.type || "-"}</td>
        <td class="px-4 py-3">${when}</td>
        <td class="px-4 py-3">
          <button class="px-3 py-1 rounded-lg bg-rose-600 text-white hover:bg-rose-700"
                  onclick="deleteAppointment(${appt.appointmentId})">
            Delete
          </button>
        </td>
    </tr>`;
  }

  async function deleteAppointment(id){
    const ok = confirm("Delete this appointment permanently?");
    if (!ok) return;
    try {
      await api(`${BASE}?id=${id}`, { method: "DELETE" });
      await loadAppointments(true);
    } catch (e) {
      alert("Failed to delete: " + e.message);
    }
  }

  function buildQuery(){
    const u = new URLSearchParams();
    const petUid = document.getElementById("f_petUid").value.trim();
    const type = document.getElementById("f_type").value;
    const status = document.getElementById("f_status").value;
    if (petUid) u.set("petUid", petUid);
    if (type) u.set("type", type);
    if (status) u.set("status", status);
    return u.toString();
  }

  async function loadAppointments(useFilters=false){
    const qs = useFilters ? buildQuery() : "";
    theUrl = qs ? `${BASE}?${qs}` : BASE;

    const res = await fetch(theUrl);
    const data = await res.json();

    const activeBody = document.getElementById("appointmentsBody");
    const completedBody = document.getElementById("completedBody");
    const canceledBody = document.getElementById("canceledBody");
    activeBody.innerHTML = "";
    completedBody.innerHTML = "";
    canceledBody.innerHTML = "";

    let activeCount = 0, completedCount = 0, canceledCount = 0;

    (Array.isArray(data) ? data : []).forEach(a=>{
      if (!a) return;
      const s = (a.status || "").toLowerCase();
      if (s === "cancelled") {
        canceledBody.insertAdjacentHTML("beforeend", rowCanceled(a));
        canceledCount++;
      } else if (s === "done") {
        completedBody.insertAdjacentHTML("beforeend", rowCompleted(a));
        completedCount++;
      } else {
        activeBody.insertAdjacentHTML("beforeend", rowActive(a));
        activeCount++;
      }
    });

    // Section counts
    document.getElementById("countActive").textContent = activeCount ? `${activeCount} items` : "No items";
    document.getElementById("countCompleted").textContent = completedCount ? `${completedCount} items` : "No items";
    document.getElementById("countCanceled").textContent = canceledCount ? `${canceledCount} items` : "No items";

    // Header quick stats
    document.getElementById("heroActive").textContent = activeCount;
    document.getElementById("heroCompleted").textContent = completedCount;
    document.getElementById("heroCancelled").textContent = canceledCount;
  }

  function resetFilters(){
    document.getElementById("f_petUid").value = "";
    document.getElementById("f_type").value = "";
    document.getElementById("f_status").value = "";
    loadAppointments();
  }

  async function api(url, options = {}) {
    const res = await fetch(url, options);
    let payload = null;
    try { payload = await res.json(); } catch {}
    if (!res.ok) {
      const msg = (payload && payload.error) || res.statusText || 'Request failed';
      throw new Error(msg);
    }
    return payload;
  }

  async function updateStatus(id, newStatus){
    try {
      await api(BASE, {
        method: "PUT",
        headers: { "Content-Type":"application/json" },
        body: JSON.stringify({ appointmentId: id, status: newStatus })
      });

      if (newStatus === 'cancelled' || newStatus === 'done') {
        const statusSel = document.getElementById('f_status');
        if (statusSel) statusSel.value = '';
      }
      await loadAppointments(true);
    } catch (e) {
      alert("Failed to update status: " + e.message);
    }
  }

  document.addEventListener("DOMContentLoaded", loadAppointments);
</script>

</body>
</html>
