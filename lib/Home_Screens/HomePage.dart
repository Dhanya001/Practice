Container(
decoration: BoxDecoration(
color: Colors.grey[300],
shape: BoxShape.circle,
border: Border.all(width: 2,color: Colors.red),
),
child: Image.network(
categoryPic,
fit: BoxFit.cover,
width: 50,
height: 50,
loadingBuilder: (context, child, loadingProgress) {
if (loadingProgress == null) {
return child;
} else {
return CircularProgressIndicator();
}
},
errorBuilder: (context, error, stackTrace) {
return Icon(
Icons.person,
size: 40,
color: Colors.grey,
);
},
),
),
//I want categorypic in circular shape but image show in rectangle
