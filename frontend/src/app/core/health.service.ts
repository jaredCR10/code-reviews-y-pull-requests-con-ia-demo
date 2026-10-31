import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { HealthResponse } from '../models/health.model';

/**
 * Única capa de acceso a la API para el endpoint de salud del backend.
 * Ningún componente debe llamar HttpClient directamente: todo pasa por
 * un servicio como este (equivalente Angular de src/api/* en la versión React).
 */
@Injectable({ providedIn: 'root' })
export class HealthService {
  private readonly http = inject(HttpClient);

  getHealth(): Observable<HealthResponse> {
    // Ruta relativa: en desarrollo la resuelve el proxy de Angular CLI
    // (proxy.conf.json) hacia http://localhost:8080; en producción la
    // resuelve el reverse proxy/configuración que el equipo defina.
    return this.http.get<HealthResponse>('/api/health');
  }
}
