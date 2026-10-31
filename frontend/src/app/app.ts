import { Component } from '@angular/core';
import { HealthStatus } from './health-status/health-status';

@Component({
  selector: 'app-root',
  imports: [HealthStatus],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App {
  protected readonly title = 'TallerAuto';
}
