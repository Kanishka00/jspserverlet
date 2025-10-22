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
            brand: { 50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75' }
          },
          boxShadow: { soft:'0 10px 30px rgba(0,0,0,.06)', glow:'0 0 0 6px rgba(47,151,255,.10)' }
        }
      },
      darkMode: 'class'
    }
  </script>
  <style>
    .bg-grid{background-image:radial-gradient(circle at 1px 1px, rgba(16,24,40,.08) 1px, transparent 0);background-size:24px 24px;mask-image:radial-gradient(ellipse 70% 60% at 50% -10%, black 40%, transparent 60%)}
    .reveal{opacity:0;transform:translateY(12px);transition:opacity .6s ease,transform .6s ease}
    .reveal.visible{opacity:1;transform:translateY(0)}
    th{font-weight:600;color:rgb(71 85 105)}
    .dark th{color:rgb(203 213 225)}
    .cal-day{cursor:pointer}
    .cal-day.disabled{opacity:.45;cursor:default}
    .cal-day.selected{outline:2px solid rgb(47,151,255);outline-offset:2px;border-radius:.75rem}
  </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

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
          <a href="<%= request.getContextPath() %>/views/appointment-management/add-appointment.jsp"
             class="inline-flex items-center justify-center px-5 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
            + Add appointment
          </a>
          <button onclick="refreshData()"
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
            <p class="mt-3 text-[11px] text-slate-500 dark:text-slate-400">Counts update as you take actions below.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

  <!-- ===== Calendar (click a day to filter tables) ===== -->
  <div class="reveal rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft p-5">
    <div class="flex items-center justify-between">
      <h2 class="font-semibold text-base">Calendar</h2>
      <div class="flex items-center gap-2">
        <button id="calPrev" class="px-3 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700">‹</button>
        <div id="calLabel" class="min-w-[12ch] text-center font-medium"></div>
        <button id="calNext" class="px-3 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700">›</button>
      </div>
    </div>

    <div class="mt-3 grid grid-cols-7 text-[11px] text-slate-500 dark:text-slate-400">
      <div class="py-1 text-center">Sun</div><div class="py-1 text-center">Mon</div><div class="py-1 text-center">Tue</div>
      <div class="py-1 text-center">Wed</div><div class="py-1 text-center">Thu</div><div class="py-1 text-center">Fri</div><div class="py-1 text-center">Sat</div>
    </div>

    <div id="calGrid" class="grid grid-cols-7 gap-1 mt-1"></div>

    <p class="mt-3 text-[11px] text-slate-500 dark:text-slate-400">
      Click a day to filter the appointment lists below. Click “Clear” on the pill to remove the filter.
    </p>
  </div>

  <!-- Active date pill -->
  <div id="dateFilterPill" class="hidden mt-6">
    <span class="inline-flex items-center gap-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 px-3 py-1 text-xs">
      <span class="text-slate-500">Filtered by</span>
      <strong id="dateFilterText" class="font-medium"></strong>
      <button class="px-2 py-0.5 rounded-lg border border-slate-300 dark:border-slate-700"
              onclick="clearDateFilter()">Clear</button>
    </span>
  </div>

  <!-- Upcoming -->
  <div class="reveal mt-6">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-xl font-bold tracking-tight">Upcoming appointments</h3>
      <span id="countActive" class="text-xs text-slate-500"></span>
    </div>

    <div class="mt-3 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
      <div class="max-h-[560px] overflow-auto">
        <table class="min-w-full text-sm table-fixed">
          <colgroup>
            <col class="w-[18rem]" />
            <col class="w-[16rem]" />
            <col class="w-[7rem]" />
            <col class="w-[10rem]" />
            <col class="w-[12rem]" />
            <col class="w-[10rem]" />
            <col class="w-[14rem]" />
            <col class="w-[8rem]" />
            <col class="w-[10rem]" />
          </colgroup>
          <thead class="bg-slate-50/70 dark:bg-slate-800/70 backdrop-blur sticky top-0 z-10 border-b border-slate-200 dark:border-slate-800">
          <tr class="text-xs font-medium text-slate-500 dark:text-slate-400">
            <th class="px-4 py-3 text-left">When</th>
            <th class="px-4 py-3 text-left">Pet</th>
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

<!-- ACTIONS MODAL -->
<div id="actionModal" class="fixed inset-0 z-[100] hidden" aria-hidden="true">
  <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm"></div>
  <div class="absolute inset-0 flex items-center justify-center p-4">
    <div class="w-full max-w-md rounded-2xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 shadow-soft"
         role="dialog" aria-modal="true" aria-labelledby="actionModalTitle">
      <div class="flex items-start justify-between gap-4 p-5 border-b border-slate-200 dark:border-slate-800">
        <div>
          <h4 id="actionModalTitle" class="font-semibold text-base">Choose an action</h4>
          <p id="actionModalSub" class="mt-0.5 text-xs text-slate-500"></p>
        </div>
        <button id="actionModalClose"
                class="px-2.5 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700 hover:shadow-soft"
                aria-label="Close">✕</button>
      </div>

      <div class="p-5 space-y-3">
        <div id="actionMeta" class="text-xs text-slate-500"></div>

        <div class="grid grid-cols-2 gap-3">
          <button id="btnConfirm"
                  class="rounded-xl border border-slate-300 dark:border-slate-700 px-4 py-2 hover:shadow-soft">
            Confirm
          </button>

          <button id="btnReminder"
                  class="rounded-xl border border-blue-300 dark:border-blue-600 bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 px-4 py-2 hover:shadow-soft">
            Send Reminder
          </button>

          <a id="btnReschedule"
             class="rounded-xl border border-slate-300 dark:border-slate-700 px-4 py-2 hover:shadow-soft text-center"
             href="#">
            Reschedule
          </a>

          <button id="btnDone"
                  class="rounded-xl border border-slate-300 dark:border-slate-700 px-4 py-2 hover:shadow-soft">
            Mark Done
          </button>

          <button id="btnCancel"
                  class="rounded-xl bg-rose-600 text-white px-4 py-2 hover:bg-rose-700 col-span-2">
            Cancel Appointment
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file= "/views/common/footer.jsp" %>

<script>
  // Reveal on scroll
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

  // Theme toggle hookup (optional header button)
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
    setIcon();
    btn && btn.addEventListener('click', () => {
      root.classList.toggle('dark');
      try { localStorage.setItem('theme', root.classList.contains('dark') ? 'dark' : 'light'); } catch (e) {}
      setIcon();
    });
  })();

  // === API ===
  const BASE = "<%= request.getContextPath() %>/appointments";
  const RES_PAGE = "<%= request.getContextPath() %>/views/appointment-management/reschedule-appointment.jsp";

  // ===== Calendar state =====
  let CAL_YEAR, CAL_MONTH; // month is 0-based
  let FILTER_DATE = null;  // "YYYY-MM-DD"
  let APPT_CACHE = [];

  // ---- helpers
  function fmtWhen(iso) {
    if (!iso) return { date: "-", time: "" };
    const d = new Date(iso);
    return {
      date: d.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' }),
      time: d.toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' })
    };
  }

  // Pet data cache to avoid repeated API calls
  const PET_CACHE = new Map();

  // Function to fetch pet details by UID
  async function fetchPetByUid(petUid) {
    if (!petUid) return null;
    
    // Check cache first
    if (PET_CACHE.has(petUid)) {
      return PET_CACHE.get(petUid);
    }
    
    try {
      console.log('Fetching pet details for UID:', petUid);
      
      // Try to get all pets first (this might not require authentication)
      const response = await fetch(`<%= request.getContextPath() %>/pets`);
      console.log('Pets endpoint response status:', response.status);
      
      if (response.ok) {
        const allPets = await response.json();
        console.log('All pets response:', allPets.length, 'pets');
        
        // Find the pet with matching UID
        const pet = allPets.find(p => p.petUid === petUid);
        if (pet) {
          console.log('Found pet by UID:', pet);
          PET_CACHE.set(petUid, pet);
          return pet;
        } else {
          console.log('No pet found with UID:', petUid);
        }
      } else {
        console.error('Pets endpoint failed with status:', response.status);
        // Fallback to search API
        console.log('Trying search API as fallback...');
        const searchResponse = await fetch(`<%= request.getContextPath() %>/api/pets/search?q=${encodeURIComponent(petUid)}`);
        if (searchResponse.ok) {
          const pets = await searchResponse.json();
          const pet = pets.find(p => p.petUid === petUid);
          if (pet) {
            PET_CACHE.set(petUid, pet);
            return pet;
          }
        }
      }
    } catch (error) {
      console.warn('Failed to fetch pet details for', petUid, ':', error);
    }
    
    // Cache null result to avoid repeated failed requests
    PET_CACHE.set(petUid, null);
    return null;
  }

  // Function to enhance appointments with pet data
  async function enhanceAppointmentsWithPetData(appointments) {
    console.log('Enhancing appointments with pet data:', appointments.length, 'appointments');
    const enhanced = [];
    
    for (const appt of appointments) {
      const enhancedAppt = { ...appt };
      
      // Fetch pet details if petUid exists
      if (appt.petUid) {
        console.log('Processing appointment with petUid:', appt.petUid);
        const pet = await fetchPetByUid(appt.petUid);
        if (pet) {
          console.log('Enhanced appointment with pet data:', pet);
          enhancedAppt.petName = pet.name;
          enhancedAppt.petSpecies = pet.species;
          enhancedAppt.petBreed = pet.breed;
          enhancedAppt.ownerName = pet.ownerName;
        } else {
          console.log('No pet data found for UID:', appt.petUid);
        }
      } else {
        console.log('Appointment has no petUid:', appt);
      }
      
      enhanced.push(enhancedAppt);
    }
    
    console.log('Enhanced appointments:', enhanced);
    return enhanced;
  }

  // Helper function to format pet display
  function formatPetDisplay(appt) {
    if (appt.petName) {
      let display = appt.petName;
      if (appt.petSpecies) {
        display += ` (${appt.petSpecies})`;
      }
      return display;
    }
    return appt.petUid || 'Unknown Pet';
  }

  // Helper function to format owner display
  function formatOwnerDisplay(appt) {
    return appt.ownerName || `Owner ID: ${appt.ownerId || 'Unknown'}`;
  }
  function pill(s) {
    const key = (s || 'pending').toLowerCase();
    const styles = {
      pending:   "bg-amber-100 text-amber-700 dark:bg-amber-200/20 dark:text-amber-300",
      confirmed: "bg-emerald-100 text-emerald-700 dark:bg-emerald-200/20 dark:text-emerald-300",
      done:      "bg-slate-100 text-slate-700 dark:bg-slate-200/10 dark:text-slate-300",
      cancelled: "bg-rose-100 text-rose-700 dark:bg-rose-200/20 dark:text-rose-300"
    }[key] || "bg-slate-100 text-slate-700 dark:bg-slate-200/10 dark:text-slate-300";
    const txt = key.charAt(0).toUpperCase() + key.slice(1);
    return `<span class="inline-flex items-center px-2.5 py-0.5 rounded-lg text-xs font-medium ${styles}">${txt}</span>`;
  }
  function paymentPill(method, status) {
    const m = (method || "-").toUpperCase();
    const s = (status || "UNPAID").toUpperCase();
    const ok = s === "PAID";
    const base = ok
            ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-200/20 dark:text-emerald-300"
            : "bg-amber-100 text-amber-700 dark:bg-amber-200/20 dark:text-amber-300";
    const label = m === "CLINIC" ? `Pay at clinic — ${s}` : `${m} — ${s}`;
    return `<span class="inline-flex rounded-lg px-2.5 py-0.5 text-xs font-medium ${base}">${label}</span>`;
  }
  function dateKey(iso) {
    if (!iso) return '';
    const d = new Date(iso);
    const y = d.getFullYear();
    const m = String(d.getMonth()+1).padStart(2,'0');
    const da= String(d.getDate()).padStart(2,'0');
    return `${y}-${m}-${da}`;
  }

  // ===== Rows =====
  function rowActive(appt){
    const { date, time } = fmtWhen(appt.scheduledAt);
    const fee = (appt.fee != null) ? `Rs${appt.fee}` : "-";
    const petDisplay = formatPetDisplay(appt);
    const ownerDisplay = formatOwnerDisplay(appt);

    const payload = encodeURIComponent(JSON.stringify({
      id: appt.appointmentId,
      method: appt.paymentMethod || '',
      status: appt.paymentStatus || '',
      petUid: appt.petUid || '',
      petName: appt.petName || '',
      petSpecies: appt.petSpecies || '',
      ownerId: appt.ownerId || '',
      ownerName: appt.ownerName || '',
      type: appt.type || '',
      phoneNo: appt.phoneNo || '',
      scheduledAt: appt.scheduledAt || '',
      fee: appt.fee
    }));

    return `<tr class="odd:bg-white even:bg-slate-50/40 dark:odd:bg-slate-900 dark:even:bg-slate-900/60 hover:bg-slate-50/70 dark:hover:bg-slate-800/40 transition">
      <td class="px-4 py-3">
        <div class="font-medium">${date}</div>
        <div class="text-xs text-slate-500">${time}</div>
      </td>
      <td class="px-4 py-3">
        <div class="font-medium">${petDisplay}</div>
        <div class="text-xs text-slate-500 font-mono">UID: ${appt.petUid || "-"}</div>
      </td>
      <td class="px-4 py-3">
        <div class="font-medium">${ownerDisplay}</div>
        ${appt.ownerId ? `<div class="text-xs text-slate-500">ID: ${appt.ownerId}</div>` : ''}
      </td>
      <td class="px-4 py-3">${appt.type || "-"}</td>
      <td class="px-4 py-3"><span class="tabular-nums">${appt.phoneNo || "-"}</span></td>
      <td class="px-4 py-3">${pill(appt.status)}</td>
      <td class="px-4 py-3">${paymentPill(appt.paymentMethod, appt.paymentStatus)}</td>
      <td class="px-4 py-3"><span class="font-medium">${fee}</span></td>
      <td class="px-4 py-3">
        <button class="px-3 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700 hover:shadow-soft transition"
                onclick="openActionModal('${payload}')">
          Actions
        </button>
      </td>
    </tr>`;
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
        <button class="px-3 py-1.5 rounded-lg bg-rose-600 text-white hover:bg-rose-700"
                onclick="deleteAppointment(${appt.appointmentId})">
          Delete
        </button>
      </td>
    </tr>`;
  }

  // ===== Date filter (calendar → tables) =====
  function setCalendarFilter(dateISO) {
    FILTER_DATE = dateISO;
    updateDatePill();
    renderTables();
    highlightSelectedDay();
  }
  function clearDateFilter() {
    FILTER_DATE = null;
    updateDatePill();
    renderTables();
    highlightSelectedDay();
  }
  function updateDatePill(){
    const pill = document.getElementById('dateFilterPill');
    const txt  = document.getElementById('dateFilterText');
    if (!pill) return;
    if (FILTER_DATE) {
      const d = new Date(FILTER_DATE + 'T00:00:00');
      txt.textContent = d.toLocaleDateString(undefined, { year:'numeric', month:'short', day:'numeric' });
      pill.classList.remove('hidden');
    } else {
      pill.classList.add('hidden');
    }
  }

  // ===== Calendar rendering =====
  function monthLabel(y,m){ return new Date(y,m,1).toLocaleString(undefined,{month:'long',year:'numeric'}); }
  function startOfMonth(y,m){ return new Date(y,m,1); }
  function endOfMonth(y,m){ return new Date(y,m+1,0); } // last day
  function ymd(d){ const y=d.getFullYear(), m=String(d.getMonth()+1).padStart(2,'0'), da=String(d.getDate()).padStart(2,'0'); return `${y}-${m}-${da}`; }

  function computeCountsByDate(list){
    const map = Object.create(null);
    list.forEach(a => {
      const key = dateKey(a.scheduledAt);
      if (!key) return;
      map[key] = (map[key] || 0) + 1; // count all statuses; tweak if you only want active
    });
    return map;
  }

  function renderCalendar(){
    const label = document.getElementById('calLabel');
    const grid  = document.getElementById('calGrid');
    if (!label || !grid) return;

    label.textContent = monthLabel(CAL_YEAR, CAL_MONTH);
    grid.innerHTML = "";

    const first = startOfMonth(CAL_YEAR, CAL_MONTH);
    const last  = endOfMonth(CAL_YEAR, CAL_MONTH);

    const lead = first.getDay();                // blanks before the 1st
    const days = last.getDate();                // number of days in month
    const counts = computeCountsByDate(APPT_CACHE);

    // leading blanks (previous month)
    for (let i=0;i<lead;i++){
      grid.insertAdjacentHTML('beforeend',
              `<div class="p-2 rounded-xl text-center text-xs text-slate-400 dark:text-slate-600 bg-slate-50 dark:bg-slate-800/40"> </div>`);
    }

    // days
    for (let d=1; d<=days; d++){
      const dt = new Date(CAL_YEAR, CAL_MONTH, d);
      const key = ymd(dt);
      const count = counts[key] || 0;

      const isToday = key === ymd(new Date());
      const isSelected = FILTER_DATE === key;

      grid.insertAdjacentHTML('beforeend', `
        <button
          class="cal-day ${isSelected ? 'selected' : ''} rounded-xl text-left p-2 border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft"
          data-cal-date="${key}">
          <div class="flex items-center justify-between">
            <span class="text-sm font-medium ${isToday ? 'text-brand-700' : ''}">${d}</span>
            ${count ? `<span class="inline-flex items-center justify-center text-[10px] px-1.5 py-0.5 rounded-full bg-brand-600 text-white">${count}</span>` : ''}
          </div>
        </button>
      `);
    }

    // trailing blanks to complete the grid
    const totalCells = lead + days;
    const tail = (7 - (totalCells % 7)) % 7;
    for (let i=0;i<tail;i++){
      grid.insertAdjacentHTML('beforeend',
              `<div class="p-2 rounded-xl text-center text-xs text-slate-400 dark:text-slate-600 bg-slate-50 dark:bg-slate-800/40"> </div>`);
    }
  }

  function highlightSelectedDay(){
    document.querySelectorAll('[data-cal-date]').forEach(el=>{
      el.classList.toggle('selected', FILTER_DATE === el.getAttribute('data-cal-date'));
    });
  }

  // calendar nav
  document.addEventListener('click', (e)=>{
    const cell = e.target.closest('[data-cal-date]');
    if (cell){ setCalendarFilter(cell.getAttribute('data-cal-date')); }
  });
  document.getElementById('calPrev').addEventListener('click', ()=>{
    CAL_MONTH--; if (CAL_MONTH<0){ CAL_MONTH=11; CAL_YEAR--; }
    renderCalendar(); highlightSelectedDay();
  });
  document.getElementById('calNext').addEventListener('click', ()=>{
    CAL_MONTH++; if (CAL_MONTH>11){ CAL_MONTH=0; CAL_YEAR++; }
    renderCalendar(); highlightSelectedDay();
  });

  // ===== Data rendering =====
  function renderTables(){
    const activeBody    = document.getElementById("appointmentsBody");
    const completedBody = document.getElementById("completedBody");
    const canceledBody  = document.getElementById("canceledBody");
    activeBody.innerHTML = completedBody.innerHTML = canceledBody.innerHTML = "";

    let activeCount=0, completedCount=0, canceledCount=0;

    const list = FILTER_DATE
            ? APPT_CACHE.filter(a => dateKey(a.scheduledAt) === FILTER_DATE)
            : APPT_CACHE;

    list.forEach(a=>{
      const s = (a.status || "").toLowerCase();
      if (s === "cancelled") { canceledBody.insertAdjacentHTML("beforeend", rowCanceled(a));  canceledCount++; }
      else if (s === "done") { completedBody.insertAdjacentHTML("beforeend", rowCompleted(a)); completedCount++; }
      else { activeBody.insertAdjacentHTML("beforeend", rowActive(a)); activeCount++; }
    });

    document.getElementById("countActive").textContent    = activeCount    ? `${activeCount} items`    : "No items";
    document.getElementById("countCompleted").textContent = completedCount ? `${completedCount} items` : "No items";
    document.getElementById("countCanceled").textContent  = canceledCount  ? `${canceledCount} items`  : "No items";

    document.getElementById("heroActive").textContent    = activeCount;
    document.getElementById("heroCompleted").textContent = completedCount;
    document.getElementById("heroCancelled").textContent = canceledCount;
  }

  async function refreshData(){
    try {
      // Show loading state
      document.getElementById("appointmentsBody").innerHTML = 
        '<tr><td colspan="9" class="px-4 py-8 text-center text-slate-500">Loading appointment and pet details...</td></tr>';
      
      const res = await fetch(BASE);
      const data = await res.json();
      const rawAppointments = Array.isArray(data) ? data : [];
      
      // Enhance appointments with pet data
      APPT_CACHE = await enhanceAppointmentsWithPetData(rawAppointments);
      
      renderCalendar();
      renderTables();
      highlightSelectedDay();
    } catch (error) {
      console.error('Failed to refresh data:', error);
      document.getElementById("appointmentsBody").innerHTML = 
        '<tr><td colspan="9" class="px-4 py-8 text-center text-red-500">Failed to load data. Please try again.</td></tr>';
    }
  }

  // ===== Updates & actions =====
  async function api(url, options = {}) {
    const res = await fetch(url, options);
    let payload = null;
    try { payload = await res.json(); } catch {}
    if (!res.ok) {
      const msg = (payload && (payload.error || payload.message)) || res.statusText || 'Request failed';
      throw new Error(msg);
    }
    return payload;
  }

  async function updateStatus(id, newStatus){
    const actionMap = { confirmed: 'confirm', done: 'done', cancelled: 'cancel' };

    const tryPut = async (payload) => {
      const res = await fetch(BASE, {
        method: "PUT",
        headers: { "Content-Type":"application/json" },
        body: JSON.stringify(payload)
      });
      let json = null; try { json = await res.json(); } catch {}
      if (!res.ok) {
        const msg = (json && (json.error || json.message)) || res.statusText || "Request failed";
        throw new Error(msg);
      }
      return json;
    };

    const disableAll = (v) => {
      document.querySelectorAll('#actionModal button, #actionModal a').forEach(el => el.disabled = !!v);
    };

    try {
      disableAll(true);
      try {
        await tryPut({ appointmentId: id, status: newStatus });
      } catch (e1) {
        const action = actionMap[newStatus] || newStatus;
        await tryPut({ appointmentId: id, action });
      }
      try { closeActionModal(); } catch {}
      await refreshData();
    } catch (e) {
      alert("Update failed: " + e.message);
    } finally {
      disableAll(false);
    }
  }

  async function deleteAppointment(id){
    const ok = confirm("Delete this appointment permanently?");
    if (!ok) return;
    try {
      await api(`${BASE}?id=${id}`, { method: "DELETE" });
      await refreshData();
    } catch (e) {
      alert("Failed to delete: " + e.message);
    }
  }

  async function sendReminder(id){
    const ok = confirm("Send appointment reminder email to the pet owner?");
    if (!ok) return;
    
    const disableAll = (v) => {
      document.querySelectorAll('#actionModal button, #actionModal a').forEach(el => el.disabled = !!v);
    };
    
    try {
      disableAll(true);
      
      // Show loading state
      const btnReminder = document.getElementById('btnReminder');
      const originalText = btnReminder.textContent;
      btnReminder.textContent = 'Sending...';
      
      await api(`${BASE}/reminder`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ appointmentId: id })
      });
      
      alert("Reminder email sent successfully!");
      closeActionModal();
      
    } catch (e) {
      alert("Failed to send reminder: " + e.message);
    } finally {
      disableAll(false);
      const btnReminder = document.getElementById('btnReminder');
      if (btnReminder) btnReminder.textContent = 'Send Reminder';
    }
  }

  // ===== Modal logic =====
  let CURRENT_APPT = null;

  function openActionModal(payloadStr){
    try { CURRENT_APPT = JSON.parse(decodeURIComponent(payloadStr)); } catch { CURRENT_APPT = null; }
    if (!CURRENT_APPT) return;

    const sub   = document.getElementById('actionModalSub');
    const meta  = document.getElementById('actionMeta');
    sub.textContent = `Appointment #${CURRENT_APPT.id}`;
    
    const petDisplay = CURRENT_APPT.petName ? 
      (CURRENT_APPT.petSpecies ? `${CURRENT_APPT.petName} (${CURRENT_APPT.petSpecies})` : CURRENT_APPT.petName) : 
      (CURRENT_APPT.petUid || 'Unknown Pet');
    
    const ownerDisplay = CURRENT_APPT.ownerName || `Owner ID: ${CURRENT_APPT.ownerId || 'Unknown'}`;
    
    meta.innerHTML = `
      <div class="space-y-1">
        <div><span class="text-slate-400">Pet:</span> <span class="font-medium">${petDisplay}</span></div>
        <div><span class="text-slate-400">Pet UID:</span> <span class="font-mono text-xs">${CURRENT_APPT.petUid || '-'}</span></div>
        <div><span class="text-slate-400">Owner:</span> <span class="font-medium">${ownerDisplay}</span></div>
        <div><span class="text-slate-400">Type:</span> ${CURRENT_APPT.type || '-'}</div>
        <div><span class="text-slate-400">Phone:</span> ${CURRENT_APPT.phoneNo || '-'}</div>
        <div><span class="text-slate-400">Fee:</span> ${CURRENT_APPT.fee!=null?('Rs'+CURRENT_APPT.fee):'-'}</div>
      </div>
    `;

    const btnConfirm = document.getElementById('btnConfirm');
    const btnReminder = document.getElementById('btnReminder');
    const btnDone    = document.getElementById('btnDone');
    const btnCancel  = document.getElementById('btnCancel');
    const aResched   = document.getElementById('btnReschedule');

    aResched.href = `${RES_PAGE}?id=${CURRENT_APPT.id}`;

    btnConfirm.onclick = () => {
      const ok = (String(CURRENT_APPT.method).toLowerCase()==='clinic') ||
              (String(CURRENT_APPT.status).toLowerCase()==='paid');
      if(!ok){ alert("Cannot confirm until paid or pay-at-clinic is selected."); return; }
      updateStatus(CURRENT_APPT.id, 'confirmed');
    };

    btnReminder.onclick = () => sendReminder(CURRENT_APPT.id);
    btnDone.onclick   = () => updateStatus(CURRENT_APPT.id, 'done');
    btnCancel.onclick = () => updateStatus(CURRENT_APPT.id, 'cancelled');

    showActionModal();
  }

  function showActionModal(){
    const modal = document.getElementById('actionModal');
    if (!modal) return;
    modal.classList.remove('hidden');
    modal.setAttribute('aria-hidden', 'false');
    const closeBtn = document.getElementById('actionModalClose');
    closeBtn && closeBtn.focus();

    modal._escHandler = (e)=>{ if(e.key==='Escape') closeActionModal(); };
    document.addEventListener('keydown', modal._escHandler);

    modal._backdropHandler = (e)=>{
      const backdrop = modal.querySelector('.absolute.inset-0.bg-slate-900\\/60.backdrop-blur-sm');
      if (e.target === backdrop) closeActionModal();
    };
    modal.addEventListener('click', modal._backdropHandler);

    closeBtn && (closeBtn.onclick = closeActionModal);
  }

  function closeActionModal(){
    const modal = document.getElementById('actionModal');
    if (!modal) return;
    modal.classList.add('hidden');
    modal.setAttribute('aria-hidden', 'true');
    if (modal._escHandler) document.removeEventListener('keydown', modal._escHandler);
    if (modal._backdropHandler) modal.removeEventListener('click', modal._backdropHandler);
    CURRENT_APPT = null;
  }

  // boot
  document.addEventListener("DOMContentLoaded", () => {
    const now = new Date();
    CAL_YEAR = now.getFullYear();
    CAL_MONTH = now.getMonth();
    updateDatePill();
    refreshData();
  });
</script>

</body>
</html>
