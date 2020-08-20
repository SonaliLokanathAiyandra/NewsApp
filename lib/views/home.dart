import 'package:architecture/helper/data.dart';
import 'package:architecture/helper/news.dart';
import 'package:architecture/models/article_model.dart';
import 'package:architecture/models/category_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'article_view.dart';
import 'categorie_news.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() =>_HomeState();
}

class _HomeState extends State<Home>{
  List<CategoryModel>catagories = new List<CategoryModel>();
  List<ArticleModel>articles = new List<ArticleModel>();
  bool _loading =true;
  @override
  void initState(){
    super.initState();
    catagories =getCategories();
    getNews();
  }

  getNews()async{
  News newsClass = News();
  await newsClass.getNews();
  articles = newsClass.news;
  setState(() {
    _loading =false;
  });
}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("News Views", style: TextStyle(
                  color: Colors.white
              ),)
            ],
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: _loading ?
        Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ) :
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                  children: <Widget>[
SizedBox(height: 8.0),
                    ///Categories
                    Container(
                      height: 70,
                      child: ListView.builder(
                          itemCount: catagories.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CategoryTile(
                              imageUrl: catagories[index].imageUrl,
                              categoryName: catagories[index].categoryName,
                            );
                          }),
                    ),

                    ///blogs
                    Container(
                      padding: EdgeInsets.only(top: 16),

                      child: ListView.builder(
                        itemCount: articles.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder:(context, index){
                          return BlogTile(
                            imageUrl:articles[index].urlToImage,
                            title:articles[index].title,
                            desc:articles[index].description,
                            url: articles[index].url,
                          );
                          }),
                    ),
                  ],
              ),
          ),
        ),
    );
  }
  }


class CategoryTile extends StatelessWidget {

  final String imageUrl,categoryName;
  CategoryTile({this.imageUrl,this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CategoryNews(
            Category:categoryName.toLowerCase(),
          ),
        ));
    },
    child: Container(
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
              imageUrl:imageUrl,width: 120,height: 60,fit: BoxFit.cover)),
          Container(
            alignment: Alignment.center,
            width: 120,height: 60,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(categoryName,style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,

            ),),
          )
        ],
      ),
    )
    );
  }
}
class BlogTile extends StatelessWidget {

  final String imageUrl, title, desc,url;
  BlogTile({@required this.imageUrl,@required this.title,@required this.desc,@required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=>ArticleView(

          ),
        ));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            ClipRRect(child: Image.network(imageUrl),
              borderRadius: BorderRadius.circular(6),
            ),
            SizedBox(height: 8),
            Text(title,style: TextStyle(
              fontSize: 17,color: Colors.black87,
              fontWeight: FontWeight.w600
            ),),
            SizedBox(height: 8),
            Text(desc,style: TextStyle(
              color: Colors.black54
            ),),
          ],
        ),
      ),
    );
  }
}

