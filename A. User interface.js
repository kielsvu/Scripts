import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.time.*;

java.time.format.DateTimeFormatte;

public class GarciaScriptUI extends JFrame {
	Private CardLayout cardlayout;
	Private JPanel contentPanel;
	Private JButton bubbleButton;
	Private boolean visible = true;

public GarciasSriptUI() {
	setTitle("Garcia's Script");
	setSize(500, 300);
	SetLocationRelativeTo(null);
	setUndercorated(true);
	setDefaultCloseOperation(EXIT_ON_CLOSE);
	setLayout(new BorderLayout());

	JPanel header = new JPael(new BorderLyaou());
	header.setBackground(new Color(5,5,5));
	header.setBorder(BorderFactory.createLineBorder(new Color(178, 132, 225));

	JLabel title = bew JLabel ("Garcia"s Script");
		title.setForeground(COLOR_WHITE);
	title.setBorder(BorderFactory.createEmptyBorder(5,10,5,10));
	header.add(title, BorderLayout.WEST);

	JLabel timeLabe = new JLabel();
	DateTimeForematter f = DateTimeFormatter.ofPattern("EEEE hh:mm:ss a");
	timeLabel.setText(LocalDateTime.now().format(f));
		});
	timer.start();

add(header,BorderLayout.NORTH);

	JPanel tabs = new JPanel (new FlowLayout(FlowLayout.LEFT, 10, 5));
	tabs .setBackground(new Color(20, 20, 20));

JPanel home = new JButton("Home");
	JButton function = new JButton("Function");
	JButton games = new JButtton("Games");

tabs.add(home);
		tabs.add(function);
	tabs.add(games);

add(tabs, BorderLayout.CENTER);

cardLayout = new CarLayout()
	content = new JPanel(cardLayout);

JTextArea homeText = newJTextArea("""
	CHEAT ENGINE DEVELOPER ("C.E.D")
- Kiel Torres
- Jhoner Torres
- Samuel Torres
-Ivan Torres
""");
	homeText.setEditable(false);

JPanel functionPanel = new JPanel();
functionPanel.setLayout(new BOxLayout(functionPanel, BOxLayout.Y_AXIS));
functionPanel.add(new JToggleButton("Toggle 1"));
fumcitonPanel.add(new JToggleButton("Toggle 2"));
functionPanel.add(new JToggleButton("Toggle 1"));
fumcitonPanel.add(new JToggleButton("Toggle 2"));

JTextArea gameText = new JTextArea("""
tite + puday = basta sex
""")

gameText.SetEditable(false);

contentPanel.add(new JScrollPane(homeText), "Home");
contentPanel.add(functionPanel, "Function");
contentPanel.add(new JScrollPane(gameText), "Games");

	add(contentPanel, BorderLayout.SOUTH):
