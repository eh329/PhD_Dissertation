#@File dapi_folder = (label = "Folder with DAPI images", style = "directory");
#@File fitc_folder = (label = "Folder with FITC images", style = "directory");



function merging () {
	run("Close All");
	print("\\Clear");

	merged_folder = File.getParent(dapi_folder) + File.separator + "Green_Blue_merged";
	File.makeDirectory(merged_folder);
	dapi_images = getFileList(dapi_folder);
	ftc_images = getFileList(fitc_folder);

	for (i = 0; i < lengthOf(dapi_images); i++) {
		if (endsWith (dapi_images[i], ".tif")) {
		
			dapi_name = dapi_images[i];
			ftc_name = ftc_images[i];
			open(dapi_folder + File.separator + dapi_name);
			open(fitc_folder + File.separator + ftc_name);
			run("Merge Channels...", "c2=["+ftc_name+"] c3=["+dapi_name+"] create");
		
			selectImage("Composite");
			final_name = substring( dapi_name, 0, lastIndexOf( dapi_name, "wv" ) -1 ) +")";
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