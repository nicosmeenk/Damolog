package de.hwr.damolog.gui;

import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

public class MainWindow {

	public MainWindow() {
		Display display = new Display();
		final Shell shell = new Shell(display);

		shell.setText("Damolog");

		shell.pack();
		centerWindow(shell);

		shell.open();
		while (!shell.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
		display.dispose();
	}

	private void centerWindow(Shell shell) {
		Rectangle bounds = shell.getDisplay().getBounds();
		Point point = shell.getSize();
		int left = (bounds.width - point.x) / 2;
		int top = (bounds.height - point.y) / 2;
		shell.setBounds(left, top, point.x, point.y);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new MainWindow();

	}

}
