/**
 * Chequeos operacionales del backend. Es una preocupación transversal (igual que
 * {@code security}): no pertenece a ningún caso de uso ni a las capas
 * {@code api → handlers → persistence}, sino que las atraviesa.
 *
 * <p>Por ahora contiene únicamente la sonda de disponibilidad de la base de
 * datos ({@link cr.ac.ucr.tallerauto.health.DatabaseHealthProbe}) que usa el
 * endpoint de salud (readiness) de la Fase 3.</p>
 */
package cr.ac.ucr.tallerauto.health;
