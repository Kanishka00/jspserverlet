<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Request Reschedule — Happy Paws PetCare</title>

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

<%
    String apcontext = request.getContextPath();
    String idParam = request.getParameter("id");
%>

<section class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <div class="flex items-center justify-between gap-4">
        <div>
            <h1 class="font-display text-2xl md:text-3xl font-bold tracking-tight">Request Reschedule</h1>
            <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Owners can reschedule only confirmed appointments.</p>
        </div>
        <a href="<%= apcontext %>/views/user_appointments.jsp"
           class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
            ← My appointments
        </a>
    </div>

    <% if (request.getParameter("e") != null) { %>
    <div class="mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
        <%= request.getParameter("e") %>
    </div>
    <% } %>

    <div id="alert" class="hidden mt-6 rounded-xl p-4 text-sm"></div>

    <form method="post" action="<%= apcontext %>/owner/reschedule"
          class="mt-6 grid grid-cols-1 gap-4 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 p-5 shadow-soft">
        <input type="hidden" name="appointmentId" id="appointmentId" value="<%= idParam != null ? idParam : "" %>"/>

        <div class="grid sm:grid-cols-2 gap-4">
            <div>
                <label class="block text-sm font-medium mb-1">Pet UID</label>
                <input id="petUid" disabled
                       class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2 font-mono text-xs" />
            </div>
            <div>
                <label class="block text-sm font-medium mb-1">Type</label>
                <input id="type" disabled
                       class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2" />
            </div>
        </div>

        <div class="grid sm:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm font-medium mb-1">Current date</label>
                <input id="currentDate" disabled
                       class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2" />
            </div>
            <div>
                <label class="block text-sm font-medium mb-1">Current time</label>
                <input id="currentTime" disabled
                       class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2" />
            </div>
            <div>
                <label class="block text-sm font-medium mb-1">Status</label>
                <input id="status" disabled
                       class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2" />
            </div>
        </div>

        <div class="grid sm:grid-cols-2 gap-4">
            <div>
                <label for="date" class="block text-sm font-medium mb-1">New date <span class="text-rose-600">*</span></label>
                <input id="date" name="date" type="date" required
                       class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
            </div>
            <div>
                <label for="time" class="block text-sm font-medium mb-1">New time <span class="text-rose-600">*</span></label>
                <input id="time" name="time" type="time" required
                       class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
            </div>
        </div>

        <div class="flex items-center gap-3 pt-2">
            <button class="inline-flex items-center px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                Submit reschedule
            </button>
            <a href="<%= apcontext %>/views/user_appointments.jsp"
               class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                Cancel
            </a>
        </div>
    </form>
</section>

<script>
    const BASE = "<%= apcontext %>/appointments";
    const APPT_ID = "<%= idParam != null ? idParam : "" %>";

    function showAlert(type, msg){
        const el = document.getElementById('alert');
        el.className = "mt-6 rounded-xl p-4 text-sm " +
            (type === 'success'
                ? "bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50"
                : "bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50");
        el.textContent = msg;
        el.classList.remove('hidden');
    }

    function toParts(iso){
        if (!iso) return { d:"", t:"" };
        const d = new Date(iso);
        const yyyy = d.getFullYear();
        const mm = String(d.getMonth()+1).padStart(2,'0');
        const dd = String(d.getDate()).padStart(2,'0');
        const HH = String(d.getHours()).padStart(2,'0');
        const MM = String(d.getMinutes()).padStart(2,'0');
        return { d:`${yyyy}-${mm}-${dd}`, t:`${HH}:${MM}` };
    }

    async function loadAppt(){
        if (!APPT_ID) { showAlert('error','Missing appointment id.'); return; }
        const res = await fetch(`${BASE}?id=${encodeURIComponent(APPT_ID)}`);
        if (!res.ok){ showAlert('error','Failed to load appointment.'); return; }
        const a = await res.json();

        // UI fill
        document.getElementById('petUid').value = a.petUid || '';
        document.getElementById('type').value = a.type || '';
        document.getElementById('status').value = a.status || '';
        const parts = toParts(a.scheduledAt);
        document.getElementById('currentDate').value = parts.d;
        document.getElementById('currentTime').value = parts.t;

        // allow only confirmed in UI (server also enforces)
        if ((a.status || '').toLowerCase() !== 'confirmed') {
            showAlert('error','Only confirmed appointments can be rescheduled.');
            // disable inputs
            document.querySelectorAll('input,button[type="submit"]').forEach(el=>{
                el.disabled = true; el.classList.add('opacity-60','cursor-not-allowed');
            });
        }

        // min for new date = today
        const now = new Date();
        const yyyy = now.getFullYear(), mm = String(now.getMonth()+1).padStart(2,'0'), dd = String(now.getDate()).padStart(2,'0');
        document.getElementById('date').min = `${yyyy}-${mm}-${dd}`;
    }

    document.addEventListener('DOMContentLoaded', loadAppt);
</script>

</body>
</html>
