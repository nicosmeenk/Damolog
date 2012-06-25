package de.hwr.damolog.model;

/**
 * 
 * Definition der Farben Schwarz und Weiß für die Spielsteine
 * 
 * @author nsmeenk
 * 
 */
public enum Color {

	BLACK, WHITE;

	/**
	 * Gbt die Farbwerte für eine RGB Verteilung zurück
	 * 
	 * @return Farbwerte in einem Array mit 3 Zahlen (RGB)
	 */
	public int[] getRGB() {
		if (this == BLACK) {
			int[] rgb = { 0, 0, 0 };
			return rgb;
		} else if (this == WHITE) {
			int[] rgb = { 255, 255, 255 };
			return rgb;
		}
		return null;
	}
}
