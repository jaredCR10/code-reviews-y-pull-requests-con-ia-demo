/**
 * Jerarquía de excepciones de negocio ({@code BusinessException} + {@code
 * ErrorCode}), lanzadas únicamente para forzar rollback transaccional. Los
 * desenlaces de negocio esperados se modelan como variantes del Result del
 * handler, no como excepciones.
 *
 * <p>Se incorpora en la Fase 4.</p>
 */
package cr.ac.ucr.tallerauto.exception;
