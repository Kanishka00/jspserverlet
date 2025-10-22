<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Appointments — Happy Paws PetCare</title>

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

<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <!-- Title -->
    <div class="flex items-center justify-between gap-4">
        <div>
            <h1 class="font-display text-2xl md:text-3xl font-bold tracking-tight">My Appointments</h1>
            <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Review upcoming, completed, or cancelled visits.</p>
        </div>
        <div class="flex items-center gap-2">
            <a href="<%= request.getContextPath() %>/owner/pets"
               class="inline-flex items-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                My Pets
            </a>
            <button onclick="loadMine()"
                    class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                Refresh
            </button>
        </div>
    </div>

    <!-- Upcoming -->
    <div class="mt-10">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold">Upcoming</h2>
            <span id="countUpcoming" class="text-xs text-slate-500"></span>
        </div>
        <div class="mt-3 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
            <table class="min-w-full text-sm">
                <thead class="bg-slate-50 dark:bg-slate-800/50">
                <tr>
                    <th class="px-4 py-3 text-left">When</th>
                    <th class="px-4 py-3 text-left">Pet UID</th>
                    <th class="px-4 py-3 text-left">Type</th>
                    <th class="px-4 py-3 text-left">Phone</th>
                    <th class="px-4 py-3 text-left">Status</th>
                    <th class="px-4 py-3 text-left">Fee</th>
                    <th class="px-4 py-3 text-left">Payment</th>
                    <th class="px-4 py-3 text-left">Actions</th>
                </tr>
                </thead>
                <tbody id="upcomingBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
            </table>
        </div>
    </div>

    <!-- Completed -->
    <div class="mt-10">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold">Completed</h2>
            <span id="countDone" class="text-xs text-slate-500"></span>
        </div>
        <div class="mt-3 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
            <table class="min-w-full text-sm">
                <thead class="bg-slate-50 dark:bg-slate-800/50">
                <tr>
                    <th class="px-4 py-3 text-left">ID</th>
                    <th class="px-4 py-3 text-left">Pet UID</th>
                    <th class="px-4 py-3 text-left">Type</th>
                    <th class="px-4 py-3 text-left">Completed at</th>
                </tr>
                </thead>
                <tbody id="doneBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
            </table>
        </div>
    </div>

    <!-- Cancelled -->
    <div class="mt-10">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold">Cancelled</h2>
            <span id="countCancelled" class="text-xs text-slate-500"></span>
        </div>
        <div class="mt-3 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
            <table class="min-w-full text-sm">
                <thead class="bg-slate-50 dark:bg-slate-800/50">
                <tr>
                    <th class="px-4 py-3 text-left">ID</th>
                    <th class="px-4 py-3 text-left">Pet UID</th>
                    <th class="px-4 py-3 text-left">Type</th>
                    <th class="px-4 py-3 text-left">Scheduled at</th>
                </tr>
                </thead>
                <tbody id="cancelledBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
            </table>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>

<script>
    // API endpoints
    const BASE     = "<%= request.getContextPath() %>/my-appointments"; // owner-scoped servlet
    const RES_PAGE = "<%= request.getContextPath() %>/owner/reschedule?id="; // server enforces "confirmed"

    function pill(s) {
        const c = {
            pending:"bg-amber-100 text-amber-700",
            confirmed:"bg-emerald-100 text-emerald-700",
            done:"bg-slate-200 text-slate-700",
            cancelled:"bg-rose-100 text-rose-700"
        }[(s||'pending').toLowerCase()] || "bg-slate-100 text-slate-700";
        const p = s ? s.charAt(0).toUpperCase()+s.slice(1) : "Pending";
        return `<span class="inline-flex items-center px-2 py-0.5 rounded-lg text-xs ${c}">${p}</span>`;
    }

    function ownerActionCell(a){
        const s = (a.status || '').toLowerCase();
        if (s === 'confirmed') {
            return `
        <a href="${RES_PAGE}${a.appointmentId}"
           class="px-3 py-1 rounded-lg border hover:shadow-soft inline-flex items-center">
          Request reschedule
        </a>`;
        }
        return `<span class="text-xs text-slate-500">Request Reschedule</span>`;
    }

    function rowUpcoming(a){
        const when = a.scheduledAt ? new Date(a.scheduledAt).toLocaleString() : "-";
        const payTxt = (() => {
            const m = (a.paymentMethod || '-').toUpperCase();
            const s = (a.paymentStatus || 'UNPAID').toUpperCase();
            return m === 'CLINIC' ? 'Pay at clinic — ' + s : `${m} — ${s}`;
        })();

        return `<tr>
          <td class="px-4 py-3">${when}</td>
          <td class="px-4 py-3 font-mono text-xs">${a.petUid || "-"}</td>
          <td class="px-4 py-3">${a.type || "-"}</td>
          <td class="px-4 py-3">${a.phoneNo || "-"}</td>
          <td class="px-4 py-3">${pill(a.status)}</td>
          <td class="px-4 py-3">Rs${a.fee != null ? a.fee : "-"}</td>
          <td class="px-4 py-3">${payTxt}</td>
          <td class="px-4 py-3">
            <div class="flex flex-wrap gap-2">
              ${ownerActionCell(a)}
              <button class="px-3 py-1 rounded-lg bg-rose-600 text-white hover:bg-rose-700"
                      onclick="cancelAppt(${a.appointmentId})">Cancel</button>
            </div>
          </td>
        </tr>`;
    }


        function rowDone(a){
        const when = a.scheduledAt ? new Date(a.scheduledAt).toLocaleString() : "-";
        return `<tr>
      <td class="px-4 py-3">${a.appointmentId}</td>
      <td class="px-4 py-3 font-mono text-xs">${a.petUid || "-"}</td>
      <td class="px-4 py-3">${a.type || "-"}</td>
      <td class="px-4 py-3">${when}</td>
    </tr>`;
    }

    function rowCancelled(a){
        const when = a.scheduledAt ? new Date(a.scheduledAt).toLocaleString() : "-";
        return `<tr>
      <td class="px-4 py-3">${a.appointmentId}</td>
      <td class="px-4 py-3 font-mono text-xs">${a.petUid || "-"}</td>
      <td class="px-4 py-3">${a.type || "-"}</td>
      <td class="px-4 py-3">${when}</td>
    </tr>`;
    }

    async function api(url, options = {}){
        const res = await fetch(url, options);
        let payload = null; try { payload = await res.json(); } catch {}
        if(!res.ok){
            const msg = (payload && payload.error) || res.statusText || 'Request failed';
            throw new Error(msg);
        }
        return payload;
    }

    async function loadMine(){
        const data = await api(BASE);
        const up = document.getElementById('upcomingBody');
        const dn = document.getElementById('doneBody');
        const cn = document.getElementById('cancelledBody');
        up.innerHTML = dn.innerHTML = cn.innerHTML = "";

        let cUp=0, cDn=0, cCn=0;
        (Array.isArray(data)?data:[]).forEach(a=>{
            const s = (a.status||"").toLowerCase();
            if (s === 'done') { dn.insertAdjacentHTML('beforeend', rowDone(a)); cDn++; }
            else if (s === 'cancelled') { cn.insertAdjacentHTML('beforeend', rowCancelled(a)); cCn++; }
            else { up.insertAdjacentHTML('beforeend', rowUpcoming(a)); cUp++; }
        });

        document.getElementById('countUpcoming').textContent  = cUp ? `${cUp} items` : 'No items';
        document.getElementById('countDone').textContent       = cDn ? `${cDn} items` : 'No items';
        document.getElementById('countCancelled').textContent  = cCn ? `${cCn} items` : 'No items';
    }

    async function cancelAppt(id){
        if(!confirm("Cancel this appointment?")) return;
        try{
            await api(BASE, {
                method:'PUT',
                headers:{'Content-Type':'application/json'},
                body: JSON.stringify({ appointmentId:id, action:'cancel' })
            });
            await loadMine();
        } catch(e) { alert(e.message); }
    }

    document.addEventListener('DOMContentLoaded', loadMine);
</script>

</body>
</html>
