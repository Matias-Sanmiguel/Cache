package com.cache.config;

import com.cache.security.JwtFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

// API stateless con JWT: sin sesión de servlet, sin csrf, /auth/** abierto, el resto protegido.
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtFilter jwtFilter;

    @Value("${app.cors.allowed-origins}")
    private List<String> allowedOrigins;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .cors(Customizer.withDefaults())
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // preflight CORS
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        // registro/login/refresh/logout
                        .requestMatchers("/api/auth/**").permitAll()
                        // clima: widget público, sin token (pipeline Open-Meteo → kafka → redis)
                        .requestMatchers(HttpMethod.GET, "/api/weather").permitAll()

                        // ── MERCHANT (VENUE_OWNER) · gestión, analytics y métricas ──
                        // (ADMIN conserva acceso a la gestión/dashboard)
                        .requestMatchers(HttpMethod.GET, "/api/events/mine").hasAnyRole("VENUE_OWNER", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/events").hasAnyRole("VENUE_OWNER", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/events/**").hasAnyRole("VENUE_OWNER", "ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/events/**").hasAnyRole("VENUE_OWNER", "ADMIN")
                        .requestMatchers("/api/dashboard/**").hasAnyRole("VENUE_OWNER", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/api/venues/*/trends").hasAnyRole("VENUE_OWNER", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/api/venues/*/presence").hasAnyRole("VENUE_OWNER", "ADMIN")

                        // ── CLIENTE (VISITOR) · check-in y funcionalidades sociales ──
                        .requestMatchers("/api/checkin/**").hasRole("VISITOR")
                        .requestMatchers("/api/friends/**").hasRole("VISITOR")
                        .requestMatchers(HttpMethod.GET, "/api/recommendations/**").hasRole("VISITOR")
                        .requestMatchers(HttpMethod.GET, "/api/events/*/friends-attending").hasRole("VISITOR")
                        // stream SSE: EventSource no manda header → token por query param,
                        // validado en el controller (debe ir ANTES de la regla general)
                        .requestMatchers(HttpMethod.GET, "/api/notifications/stream").permitAll()
                        // pings = notificaciones sociales — cualquier rol autenticado puede ver los suyos
                        .requestMatchers(HttpMethod.GET, "/api/notifications/**").authenticated()

                        // ── catálogo público (lectura) · feed/detalle se renderiza SSR sin token ──
                        .requestMatchers(HttpMethod.GET, "/api/events/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/venues/**").permitAll()

                        // todo lo demás requiere un access token válido (perfil, notificaciones…)
                        .anyRequest().authenticated())
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    // CORS para el frontend next — integrado en la cadena de security (el @Bean de MVC no alcanza)
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(allowedOrigins);
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        config.setAllowedHeaders(List.of("*"));
        config.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }
}
