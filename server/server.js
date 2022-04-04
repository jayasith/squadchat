const express = require("express");
const fileUpload = require("express-fileupload");
const app = express();

app.use(fileUpload());
app.use(
	"/public/uploads/images/profile",
	express.static(__dirname + "/public/uploads/images/profile")
);

app.post("/upload", (req, res) => {
	let uploadFile;
	let uploadPath;

	if (req.files === null) return res.status(400).json("No file uploaded");

	uploadFile = req.files?.picture;
	uploadPath = __dirname + "/public/uploads/images/profile/" + uploadFile.name;

	uploadFile.mv(uploadPath, err => {
		if (err) return res.status(500).json(err);

		res.send("/public/uploads/images/profile/" + uploadFile.name);
	});
});

app.get("/", (req, res) => {
	res.send("Response from image server");
});

app.listen(3000, () => {
	console.log("Server up and running on port " + 3000);
});
