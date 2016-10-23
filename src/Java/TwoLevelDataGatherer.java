import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.File;
import java.util.List;
import java.util.ArrayList;


/* From command line, run
        1) javac TwoLevelDataGatherer.java
        2) java TwoLevelDataGatherer ../2LevelData/[benchmark_name]/
*/

public class TwoLevelDataGatherer {

	private static final String TWO_LEVEL_DATA_FILE = "TwoLevelGshareData.csv";

	public List<DataLine> gatherDataFromFolder(String folderName) {
		List<DataLine> dataLines = new ArrayList<DataLine>();
		File folder = new File(folderName);
		// keep this at top level folder, ./2LevelData/
		File[] benchmarkFolders = folder.listFiles();

		for (File benchmarkFolder : benchmarkFolders) {
			if (benchmarkFolder.isDirectory()) {
				File [] files = benchmarkFolder.listFiles();
				for (File file : files) {
					if (file.isFile() && file.getName().contains(("2lev"))) {
						dataLines.add(gatherFileData(file, benchmarkFolder.getName()));
					}
				}
			}
		}
		return dataLines;
	}

	private DataLine gatherFileData(File file, String benchmark) {
		String absoluteFilePath = file.getAbsolutePath();
		String fileName = file.getName();
		/* removes file extension */
		fileName = fileName.substring(0, fileName.lastIndexOf('.'));

		String branchCount = "";
		String bPredMisses = "";
		Config config = null;

		try {
			BufferedReader br = new BufferedReader(new FileReader(absoluteFilePath));
			StringBuilder sb = new StringBuilder();
   			String line = br.readLine();
			while (line != null) {
				if (line.contains("bpred:2lev") && line.contains("(<l1size> <l2size> <hist_size> <xor>)")) {
					config = getFileConfig(line);
				}
				if (line.contains("sim_total_branches")) {
					String[] splits = line.split("\\s+");
					branchCount = splits[1];
				}
				if (line.contains("bpred_2lev.misses")) {
					String[] splits = line.split("\\s+");
					bPredMisses = splits[1];
				}
				line = br.readLine();
			}
		} catch (IOException e) { }
		DataLine dataLine= new DataLine(benchmark, config, bPredMisses, branchCount);
		return dataLine;
	}

	private Config getFileConfig(String line) {
		String [] config = line.split("\\s+");
		String l1Size = config[1];
		String l2Size = config[2];
		String historyWidth = config[3];
		String xor = config[4];
		String configType = getConfigType(l1Size, l2Size, historyWidth);
		return new Config(configType, l1Size, l2Size, historyWidth, xor);
	}

	private String getConfigType(String l1, String l2, String hist) {
		Integer l1Size = Integer.parseInt(l1);
		Integer l2Size = Integer.parseInt(l2);
		Integer historyWidth = Integer.parseInt(hist);

		if (l1Size == 1) {
			return "GAg";
		}
		if (l1Size == 512 && l2Size == Math.pow(2, historyWidth)) {
			return "PAg";
		}
		if (l1Size == 512 && l2Size == l1Size*Math.pow(2, historyWidth)) {
			return "PAp";
		}
		return "No_Matching_Config_Type_ERROR";
	}

	private void writeDataToFile(List<DataLine> dataLines) {
		try {
			File fileOut = new File(TWO_LEVEL_DATA_FILE);
			fileOut.createNewFile();
			BufferedWriter writer = new BufferedWriter(new FileWriter(fileOut.getName(), false));
			for (DataLine dataLine : dataLines) {
				String lineOut = dataLine.benchmark + "," +
						         dataLine.config.configType + "," +
						         dataLine.config.l1Size + "," +
						         dataLine.config.l2Size + "," +
						         dataLine.config.historyWidth + "," +
						         dataLine.config.xor + "," +
						         dataLine.bPredMisses + "," +
						         dataLine.numBranches;
				writer.write(lineOut);
				writer.newLine();
			}
			writer.flush();
		} catch (IOException e) { }
	}

	private class Config {
		private String configType;
		private String l1Size;
		private String l2Size;
		private String historyWidth;
		private String xor;

		public Config(String configType, String l1Size, String l2Size, String historyWidth, String xor) {
			this.configType = configType;
			this.l1Size = l1Size;
			this.l2Size = l2Size;
			this.historyWidth = historyWidth;
			this.xor = xor;
		}
	}

	private class DataLine {
		private String benchmark;
		private Config config;
		private String bPredMisses;
		private String numBranches;

		public DataLine(String benchmark, Config config, String bPredMisses, String numBranches) {
			this.benchmark = benchmark;
			this.config = config;
			this.bPredMisses = bPredMisses;
			this.numBranches = numBranches;
		}
	}

	public static void main (String [] args) {
		TwoLevelDataGatherer gatherer = new TwoLevelDataGatherer();
		List<DataLine> dataLines = gatherer.gatherDataFromFolder(args[0]);
		gatherer.writeDataToFile(dataLines);
	}

}