
/**
 * CobaltApplication.java
 * @author Evan Liberto
 * @copyright (c) 2025 Evan Liberto
 * @version 1.0
 * @date 2025-05-08
 */

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellRenderer;

import java.awt.*;
import java.io.FileInputStream;
import java.sql.*;
import java.util.Properties;

/**
 * CobaltApplication.java
 * This is a Java application for viewing USGS Cobalt project data.
 * It allows users to view normalized and original tables, execute stored proecedures,
 * and inspect data through dynamic tables with interative features
 */
public class CobaltApplication {

    // Database and UI components
    private static Connection connection;
    private static JFrame frame;
    private static JTable dataTable;
    private static JTable procResultTable;

    /**
     * Sets up the main application window
     */
    private static void setFrameSettings() {
        frame = new JFrame("Cobalt Final Project Application");
        frame.setSize(1200, 700);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(new BorderLayout());
        frame.setResizable(false);
    }

    /**
     * Connects to the database using db.properties for necessary credentials.
     */
    private static void connectToDatabase() throws Exception {
        Properties properties = new Properties();
        FileInputStream input = new FileInputStream("src/db.properties");
        properties.load(input);

        String dataBaseURL = properties.getProperty("db.url");
        String user = properties.getProperty("db.user");
        String password = properties.getProperty("db.password");

        connection = DriverManager.getConnection(dataBaseURL, user, password);
    }

    /**
     * Builds all UI panels and attaches necessary listeners
     */
    private static void initializeUI() {
        JTabbedPane tabbedPane = new JTabbedPane();

        // ========== Table Viewer Tab ========== //
        JPanel viewerPanel = new JPanel(new BorderLayout());

        // View and Table dropdowns, Load and Clear Buttons
        JComboBox<String> viewSelector = new JComboBox<>(new String[] { "Original", "Normalized" });
        JComboBox<String> tableSelector = new JComboBox<>();
        tableSelector.setPreferredSize(new Dimension(250, 25));

        JButton loadButton = new JButton("Load");
        loadButton.setPreferredSize(new Dimension(80, 25));

        JButton clearButton = new JButton("Clear");
        clearButton.setPreferredSize(new Dimension(80, 25));
        clearButton.addActionListener(e -> {
            dataTable.setModel(new DefaultTableModel());
        });

        // Top Panel for controls
        JPanel topPanel = new JPanel();
        topPanel.add(new JLabel("View:"));
        topPanel.add(viewSelector);
        topPanel.add(new JLabel("Table:"));
        topPanel.add(tableSelector);
        topPanel.add(loadButton);
        topPanel.add(clearButton);

        // Data table for viewing selected table contents
        dataTable = new JTable();
        dataTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);

        // Displays a popup with full row content when row is clicked
        dataTable.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                if (evt.getClickCount() == 1 && dataTable.getSelectedRow() != -1) {
                    int row = dataTable.getSelectedRow();
                    int columnCount = dataTable.getColumnCount();
                    StringBuilder message = new StringBuilder("Row Details:\n\n");

                    for (int col = 0; col < columnCount; col++) {
                        String columnName = dataTable.getColumnName(col);
                        Object value = dataTable.getValueAt(row, col);
                        message.append(columnName).append(": ").append(value).append("\n");
                    }

                    JOptionPane.showMessageDialog(frame, message.toString(), "Row Info",
                            JOptionPane.INFORMATION_MESSAGE);
                }
            }
        });

        // Scroll Pane for the table
        JScrollPane scrollPane = new JScrollPane(dataTable,
                JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED,
                JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        viewerPanel.add(topPanel, BorderLayout.NORTH);
        viewerPanel.add(scrollPane, BorderLayout.CENTER);

        // Populates tableSelector based on view selection
        viewSelector.addActionListener(e -> {
            tableSelector.removeAllItems();
            String[] tables = viewSelector.getSelectedItem().equals("Original")
                    ? getOriginalTables()
                    : getNormalizedTables();
            for (String table : tables) {
                tableSelector.addItem(table);
            }
        });
        viewSelector.setSelectedItem("Original");

        // Loads the selected table into the viewer
        loadButton.addActionListener(e -> {
            String selectedTable = (String) tableSelector.getSelectedItem();
            if (selectedTable == null)
                return;
            try {
                ResultSet rs = fetchTableData(selectedTable);
                populateTable(rs, dataTable);
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(frame, "Error loading table:\n" + ex.getMessage());
            }
        });

        // ========== STORED PROCEDURES TAB ========== //
        JPanel procPanel = new JPanel(new BorderLayout());
        JPanel procControlPanel = new JPanel(new BorderLayout());

        // ---------- LEFT PROCEDURES TAB ---------- //
        JPanel leftProcPanel = new JPanel(new GridBagLayout());
        JPanel leftContent = new JPanel();
        leftContent.setLayout(new BoxLayout(leftContent, BoxLayout.Y_AXIS));
        leftContent.setAlignmentX(Component.CENTER_ALIGNMENT);

        JLabel cleanLabel = new JLabel(
                "CleanIndicatorValue(): Cleans '.111' suffix from 'contained' values in Resources.");
        cleanLabel.setAlignmentX(Component.CENTER_ALIGNMENT);

        JButton cleanButton = new JButton("Run CleanIndicatorValue()");
        cleanButton.setAlignmentX(Component.CENTER_ALIGNMENT);
        cleanButton.addActionListener(e -> {
            try {
                ResultSet rs = runCleanIndicatorProcedure();
                populateTable(rs, procResultTable);
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(frame, "Error running CleanIndicatorValue():\n" + ex.getMessage());
            }
        });

        leftContent.add(cleanLabel);
        leftContent.add(Box.createVerticalStrut(10));
        leftContent.add(cleanButton);
        leftProcPanel.add(leftContent);

        // ---------- RIGHT PROCEDURE: CommodityAndFeatureLookout ---------- //
        JPanel rightProcPanel = new JPanel(new GridBagLayout());
        JPanel rightContent = new JPanel();
        rightContent.setLayout(new BoxLayout(rightContent, BoxLayout.Y_AXIS));
        rightContent.setAlignmentX(Component.CENTER_ALIGNMENT);

        JLabel lookoutLabel = new JLabel("CommodityAndFeatureLookout(): Filters by commodity and feature type.");
        lookoutLabel.setAlignmentX(Component.CENTER_ALIGNMENT);

        JLabel lookoutExample = new JLabel("Example: Commodity = Cobalt or Copper, Feature Type = deposit or prospect");
        lookoutExample.setAlignmentX(Component.CENTER_ALIGNMENT);

        JPanel lookoutInputs = new JPanel(new FlowLayout(FlowLayout.CENTER, 5, 0));
        JTextField commodityField = new JTextField(10);
        JTextField ftrTypeField = new JTextField(10);
        JButton lookoutButton = new JButton("Run Lookout");

        lookoutButton.addActionListener(e -> {
            String commodity = commodityField.getText();
            String ftrType = ftrTypeField.getText();
            if (commodity.isEmpty() || ftrType.isEmpty()) {
                JOptionPane.showMessageDialog(frame, "Please enter both commodity and feature type.");
                return;
            }
            try {
                ResultSet rs = runCommodityAndFeatureLookout(commodity, ftrType);
                populateTable(rs, procResultTable);
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(frame, "Error running lookout:\n" + ex.getMessage());
            }
        });

        lookoutInputs.add(new JLabel("Commodity:"));
        lookoutInputs.add(commodityField);
        lookoutInputs.add(new JLabel("Feature Type:"));
        lookoutInputs.add(ftrTypeField);
        lookoutInputs.add(lookoutButton);

        rightContent.add(lookoutLabel);
        rightContent.add(Box.createVerticalStrut(5));
        rightContent.add(lookoutExample);
        rightContent.add(Box.createVerticalStrut(10));
        rightContent.add(lookoutInputs);
        rightProcPanel.add(rightContent);

        // Combines both of the procedure panels
        JPanel headerPanel = new JPanel(new GridLayout(1, 2));
        headerPanel.add(leftProcPanel);
        headerPanel.add(rightProcPanel);
        procControlPanel.add(headerPanel, BorderLayout.NORTH);

        // Results table for stored procedures
        procResultTable = new JTable();
        procResultTable.setAutoResizeMode(JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);

        // Popup to show full row contents on click
        procResultTable.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                if (evt.getClickCount() == 1 && procResultTable.getSelectedRow() != -1) {
                    int row = procResultTable.getSelectedRow();
                    int columnCount = procResultTable.getColumnCount();
                    StringBuilder message = new StringBuilder("Row Details:\n\n");

                    for (int col = 0; col < columnCount; col++) {
                        String columnName = procResultTable.getColumnName(col);
                        Object value = procResultTable.getValueAt(row, col);
                        message.append(columnName).append(": ").append(value).append("\n");
                    }

                    JOptionPane.showMessageDialog(frame, message.toString(), "Row Info",
                            JOptionPane.INFORMATION_MESSAGE);
                }
            }
        });

        JScrollPane procScrollPane = new JScrollPane(procResultTable,
                JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED,
                JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        procPanel.add(procControlPanel, BorderLayout.NORTH);
        procPanel.add(procScrollPane, BorderLayout.CENTER);

        // Adds Tabs and Show Frame
        tabbedPane.addTab("Table Viewer", viewerPanel);
        tabbedPane.addTab("Stored Procedures", procPanel);

        frame.add(tabbedPane, BorderLayout.CENTER);

        // Resets the user input when returning to the Stored Procedures tab
        tabbedPane.addChangeListener(e -> {
            int selectedIndex = tabbedPane.getSelectedIndex();
            String selectedTabTitle = tabbedPane.getTitleAt(selectedIndex);
            if (selectedTabTitle.equals("Stored Procedures")) {
                commodityField.setText("");
                ftrTypeField.setText("");
            }
        });

    }

    /**
     * Fetches all rows from the selected table
     * 
     * @param tableName String The Selected table
     * @return The results from the SQL query
     * @throws SQLException
     */
    private static ResultSet fetchTableData(String tableName) throws SQLException {
        String query = "SELECT * FROM usgs_cobalt_us_project." + tableName;
        Statement statement = connection.createStatement();
        return statement.executeQuery(query);
    }

    /**
     * Populates the provided JTable with the result set data
     * 
     * @param resultSet ResultSet the results from the SQL query
     * @param table JTable the JTable to add the results to.
     * @throws SQLException
     */
    private static void populateTable(ResultSet resultSet, JTable table) throws SQLException {
        ResultSetMetaData meta = resultSet.getMetaData();
        int columnCount = meta.getColumnCount();
        String[] columnNames = new String[columnCount];

        for (int i = 1; i <= columnCount; i++) {
            columnNames[i - 1] = meta.getColumnName(i);
        }

        DefaultTableModel model = new DefaultTableModel(columnNames, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        while (resultSet.next()) {
            Object[] rowData = new Object[columnCount];
            for (int i = 0; i < columnCount; i++) {
                rowData[i] = resultSet.getObject(i + 1);
            }
            model.addRow(rowData);
        }

        table.setModel(model);
        resizeColumnWidths(table);
        table.setAutoCreateRowSorter(true);

    }

    /**
     * Resizes columns to fit their content
     * 
     * @param table JTable the JTable that we are fitting to the UI
     */
    private static void resizeColumnWidths(JTable table) {
        for (int column = 0; column < table.getColumnCount(); column++) {
            int width = 75; // Minimum width
            for (int row = 0; row < table.getRowCount(); row++) {
                TableCellRenderer renderer = table.getCellRenderer(row, column);
                Component comp = table.prepareRenderer(renderer, row, column);
                width = Math.max(comp.getPreferredSize().width + 10, width);
            }
            table.getColumnModel().getColumn(column).setPreferredWidth(width);
        }
    }

    /**
     * List of Original Table Names
     * 
     * @return A List of Strings that correspond to the Original Table Names
     *          that are able to be selected by the user
     */
    private static String[] getOriginalTables() {
        return new String[] {
                "original_loc_pt", "original_geol_min_occ", "original_loc_poly",
                "original_production", "original_resources"
        };
    }

    /**
     * List of Normalized Table Names
     * These are the Normalized Tables of the Orignal Tables
     * 
     * @return A List of Strings that correspond to the Normalied Table Names
     *          that are able to be selected by the suer
     */
    private static String[] getNormalizedTables() {
        return new String[] {
                "loc_pt", "loc_pt_commodity", "loc_pt_othername", "loc_pt_ref_detail",
                "geol_min_occ", "geol_min_occ_value_material", "geol_min_occ_associated_material",
                "geol_min_occ_min_style", "geol_min_occ_min_age", "geol_min_occ_host_age",
                "geol_min_occ_host_name", "geol_min_occ_host_litho", "geol_min_occ_alteration",
                "loc_poly", "loc_poly_sw",
                "production", "resources"
        };
    }

    /**
     * Executes the CleanIndicatorValue procedure
     * 
     * @return ResultSet the results from the SQL Query
     * @throws SQLException
     */
    private static ResultSet runCleanIndicatorProcedure() throws SQLException {
        CallableStatement statement = connection.prepareCall(
                "CALL usgs_cobalt_us_project.CleanIndicatorValue()");
        return statement.executeQuery();
    }

    /**
     * Executes the CommodityAndFeatureLookout procedure
     * 
     * @param commodity String the user inputed commodity
     * @param ftrType String the user inputed ftrType
     * @return ResultSet the results from the SQL Query
     * @throws SQLException
     */
    private static ResultSet runCommodityAndFeatureLookout(String commodity, String ftrType) throws SQLException {
        CallableStatement stmt = connection.prepareCall(
                "CALL usgs_cobalt_us_project.CommodityAndFeatureLookout(?, ?)");
        stmt.setString(1, commodity);
        stmt.setString(2, ftrType);
        return stmt.executeQuery();
    }

    /**
     * Starts the application by setting up the main application window, connection
     * to the database and building the full UI.
     * 
     * @param args command-line arguments passed to the program
     */
    public static void main(String[] args) {
        setFrameSettings();
        try {
            connectToDatabase();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(frame, "Failed to connect to database:\n" + e.getMessage());
            System.exit(1);
        }

        initializeUI();
        frame.setVisible(true);
    }
}
