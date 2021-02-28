#@File dapi_folder = (label = "Folder with DAPI images", style = "directory");
#@File tr_folder = (label = "Folder with Texas Red images", style = "directory");
#@File ftc_folder = (label = "Folder with FITC images", style = "directory");


function merging () {
	run("Close All");
	print("\\Clear");

	merged_folder = File.getParent(dapi_folder) + File.separator + "Green_Blue_Red_merged";
	File.makeDirectory(merged_folder);
	dapi_images = getFileList(dapi_folder);
	ftc_images = getFileList(ftc_folder);

	for (i = 0; i < lengthOf(dapi_images); i++) {
		if (endsWith (dapi_images[i], ".tif")) {
		
			dapi_name = dapi_images[i];
			tx_name = replace(dapi_name, "DAPI", "TexasRed");
			ftc_name = ftc_images[i];
			open(dapi_folder + File.separator + dapi_name);
			open(tr_folder + File.separator + tx_name);
			open(ftc_folder + File.separator + ftc_name);
			run("Merge Channels...", "c1=["+tx_name+"] c2=["+ftc_name+"] c3=["+dapi_name+"] create");
		
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