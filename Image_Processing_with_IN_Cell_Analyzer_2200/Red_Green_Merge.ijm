#@File tr_folder = (label = "Folder with Texas Red images", style = "directory");
#@File ftc_folder = (label = "Folder with FITC images", style = "directory");



function merging () {
	run("Close All");
	print("\\Clear");

	merged_folder = File.getParent(tr_folder) + File.separator + "Red_Green_merged";
	File.makeDirectory(merged_folder);
	tr_images = getFileList(tr_folder);
	ftc_images = getFileList(ftc_folder);

	for (i = 0; i < lengthOf(tr_images); i++) {
		if (endsWith (tr_images[i], ".tif")) {
		
			tr_name = tr_images[i];
			ftc_name = ftc_images[i];
			open(tr_folder + File.separator + tr_name);
			open(ftc_folder + File.separator + ftc_name);
			run("Merge Channels...", "c1=["+tr_name+"] c2=["+ftc_name+"] create");
		
			selectImage("Composite");
			final_name = substring( tr_name, 0, lastIndexOf( tr_name, "wv" ) -1 ) +")";
			print(final_name);
			run("RGB Color");
			selectWindow("Composite");
			close();
			selectWindow("Composite (RGB)");
			saveAs("tif", merged_folder + File.separator + final_name);
			selectWindow(final_name + ".tif");
			close();
		}
	}
}



merging()