import { Component, inject, signal } from '@angular/core';
import { HealthService } from '../core/health.service';
import { HealthResponse } from '../models/health.model';

/**
 * Estado de la llamada, equivalente a la unión discriminada usada en
 * src/hooks/useHealth.ts de la versión React (idle/loading/success/error).
 */
type HealthState =
  | { status: 'loading' }
  | { status: 'success'; data: HealthResponse }
  | { status: 'error'; message: string };

/**
 * Componente de presentación: solo conoce el estado (signal) y lo muestra.
 * No llama a HttpClient directamente; delega en HealthService.
 * Esto reemplaza la plantilla de bienvenida por defecto de Angular CLI.
 */
@Component({
  selector: 'app-health-status',
  imports: [],
  templateUrl: './health-status.html',
  styleUrl: './health-status.css',
})
export class HealthStatus {
  private readonly healthService = inject(HealthService);

  readonly state = signal<HealthState>({ status: 'loading' });

  constructor() {
    this.healthService.getHealth().subscribe({
      next: (data) => this.state.set({ status: 'success', data }),
      error: () =>
        this.state.set({
          status: 'error',
          message: 'No se pudo contactar al backend en /api/health.',
        }),
    });
  }
}
