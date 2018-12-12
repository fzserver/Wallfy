import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  final String imgPath;
  FullScreenImage(this.imgPath);

  @override
  FullScreenImageState createState() => new FullScreenImageState();
  
}

class FullScreenImageState extends State<FullScreenImage> with SingleTickerProviderStateMixin {

  final LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0x10000000), Color(0x30000000)],
    begin: Alignment.topLeft, 
    end: Alignment.bottomRight
  );

  TabController tabController;

  @override
    void initState() {
      super.initState();
      tabController = TabController(length: 2, vsync: this);
    }

  @override
    void dispose() {
      tabController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context)
  =>  Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        // child: downloading
        // ? 
        // Container(
        //   decoration: BoxDecoration(gradient: backgroundGradient),
        //   child: Stack(
        //     children: <Widget>[
        //       Align(
        //         alignment: Alignment.center,
        //         child: Hero(
        //           tag: widget.imgPath,
        //           child: FadeInImage(
        //             image: NetworkImage(widget.imgPath),
        //             fit: BoxFit.cover,
        //             placeholder: AssetImage('wallfy.png'),
        //           ),
        //         ),
        //       ),
        //       Align(
        //         alignment: Alignment.topCenter,
        //         child: Card(
        //           color: Colors.transparent,
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: <Widget>[
        //               CircularProgressIndicator(),
        //               SizedBox(height: 10.0,),
        //               Text('$progress', style: TextStyle(color: Colors.white),),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ): 
        child: Container(
          decoration: BoxDecoration(gradient: backgroundGradient),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: widget.imgPath,
                  child: FadeInImage(
                    image: NetworkImage(widget.imgPath),
                    fit: BoxFit.cover,
                    placeholder: AssetImage('wallfy.png'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      elevation: 20.0,
                      splashColor: Colors.black,
                      color: Colors.black45,
                      textColor: Colors.white,
                      height: 50.0,
                      minWidth: double.infinity,
                      child: Text(
                        'DOWNLOAD IMAGE'
                      ), onPressed: () => {},
                    )
                  ],
                ),
                ),
              ],
          ),
        ),
      ),
  );
}