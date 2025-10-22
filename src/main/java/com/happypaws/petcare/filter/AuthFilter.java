//import javax.servlet.*;
//import javax.servlet.annotation.WebFilter;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//import java.io.IOException;
//import java.net.URLEncoder;
//import java.nio.charset.StandardCharsets;
//import java.util.Set;
//
//@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
//public class AuthFilter implements Filter {
//
//    // Public pages that do NOT require login
//    private static final Set<String> PUBLIC_PATHS = Set.of(
//            "/", "/index.jsp",
//            "/login",                 // in case you later serve a servlet-mapped login page
//            "/views/login.jsp",       // ← actual JSP path we use now
//            "/owner-signup.jsp", "/owner-signup",
//            "/logout"
//    );
//
//    // Public prefixes (static assets etc.)
//    private static final Set<String> PUBLIC_PREFIXES = Set.of(
//            "/assets/", "/static/", "/css/", "/js/", "/images/", "/img/", "/fonts/", "/favicon", "/webjars/"
//    );
//
//    // Model.AppointmentManagement.Staff-only screens
//    private static final Set<String> STAFF_ONLY_PREFIXES = Set.of(
//            "/views/receptionist-dashboard.jsp",
//            "/views/staff-home.jsp",
//            "/views/staff" // any subpages under /views/staff...
//    );
//
//    // Model.AppointmentManagement.Owner-only screens
//    private static final Set<String> OWNER_ONLY_PREFIXES = Set.of(
//            "/views/user_appointments.jsp",
//            "/views/user-appointments.jsp",
//            "/views/user"
//    );
//
//    // Endpoints shared (need auth but both roles may hit)
//    private static final Set<String> AUTH_SHARED_PREFIXES = Set.of(
//            "/appointments", "/owner"
//    );
//
//    // Static file extensions that should always pass
//    private static final String[] STATIC_EXTS = {
//            ".css",".js",".map",".png",".jpg",".jpeg",".gif",".svg",".ico",".webp",
//            ".woff",".woff2",".ttf",".eot"
//    };
//
//    @Override
//    public void doFilter(ServletRequest sreq, ServletResponse sres, FilterChain chain) throws IOException, ServletException {
//        HttpServletRequest req = (HttpServletRequest) sreq;
//        HttpServletResponse res = (HttpServletResponse) sres;
//
//        String ctx = req.getContextPath();
//        String uri = req.getRequestURI().substring(ctx.length()); // path within app, starts with "/"
//        if (uri.isEmpty()) uri = "/";
//
//        // 1) Always allow static resources & explicitly public pages
//        if (isStatic(uri) || isPublic(uri)) {
//            chain.doFilter(req, res);
//            return;
//        }
//
//        // 2) Check session
//        HttpSession session = req.getSession(false);
//        String authType = (session != null) ? (String) session.getAttribute("authType") : null;
//
//        // 3) If not logged in → send to login with ?next=
//        if (authType == null) {
//            redirectToLogin(req, res, ctx, uri);
//            return;
//        }
//
//        // 4) Role-based checks
//        if ("staff".equals(authType)) {
//            // block staff from owner-only pages
//            if (startsWithAny(uri, OWNER_ONLY_PREFIXES)) {
//                String role = (String) session.getAttribute("staffRole");
//                boolean isReceptionist = role != null && role.trim().equalsIgnoreCase("receptionist");
//                String staffHome = isReceptionist ? "/views/receptionist-dashboard.jsp" : "/views/staff-home.jsp";
//                res.sendRedirect(ctx + staffHome);
//                return;
//            }
//            chain.doFilter(req, res);
//            return;
//        }
//
//        if ("owner".equals(authType)) {
//            // block owners from staff-only pages
//            if (startsWithAny(uri, STAFF_ONLY_PREFIXES)) {
//                res.sendRedirect(ctx + "/views/user_appointments.jsp");
//                return;
//            }
//            chain.doFilter(req, res);
//            return;
//        }
//
//        // Unknown authType → force re-login
//        redirectToLogin(req, res, ctx, uri);
//    }
//
//    private boolean isPublic(String uri) {
//        if (PUBLIC_PATHS.contains(uri)) return true;
//        return startsWithAny(uri, PUBLIC_PREFIXES);
//    }
//
//    private boolean isStatic(String uri) {
//        for (String ext : STATIC_EXTS) {
//            if (uri.endsWith(ext)) return true;
//        }
//        return false;
//    }
//
//    private boolean startsWithAny(String value, Set<String> prefixes) {
//        for (String p : prefixes) {
//            if (value.equals(p) || value.startsWith(p)) return true;
//        }
//        return false;
//    }
//
//    private void redirectToLogin(HttpServletRequest req, HttpServletResponse res, String ctx, String uri) throws IOException {
//        String next = uri;
//        String qs = req.getQueryString();
//        if (qs != null && !qs.isEmpty()) next += "?" + qs;
//        String encoded = URLEncoder.encode(next, StandardCharsets.UTF_8.name());
//        res.sendRedirect(ctx + "/views/login.jsp?next=" + encoded);
//    }
//}


