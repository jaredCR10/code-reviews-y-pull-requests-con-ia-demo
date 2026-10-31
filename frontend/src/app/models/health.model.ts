/**
 * Espejo exacto del record `HealthResponse` del backend
 * (backend/src/main/java/cr/ac/ucr/tallerauto/api/responses/HealthResponse.java).
 * Si el backend cambia este contrato, este archivo es el único que se actualiza
 * en el frontend: todo lo demás consume este tipo.
 */
export interface HealthResponse {
  status: string;
  service: string;
}
