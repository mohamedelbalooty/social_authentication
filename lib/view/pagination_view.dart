import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_auth/controller/pagination_controller.dart';
import 'package:social_auth/model/post.dart';

class PaginationView extends StatefulWidget {
  @override
  _PaginationViewState createState() => _PaginationViewState();
}

class _PaginationViewState extends State<PaginationView> {
  PaginationController paginationController = PaginationController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Post> posts = [];
  int page = 1;
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refreshKey = GlobalKey();

  @override
  void initState() {
    paginationController.fetchPosts().then((dataFromServer) {
      setState(() {
        posts = dataFromServer;
      });
    });
    super.initState();
  }

  void _onRefresh() async{
    print(_onRefresh.toString());
    await Future.delayed(Duration(seconds: 2),);
    var dataList = await paginationController.fetchPosts(page: 1);
    posts.clear();
    page = 1;
    posts.addAll(dataList);
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async{
    page+=1;
    var dataList = await paginationController.fetchPosts(page: page);
    posts.addAll(dataList);
    await Future.delayed(Duration(seconds: 2),);
    setState(() {
      _refreshController.loadComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration.copyAncestor(
      enableLoadingWhenFailed: true,
      context: context,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pagination from api'),
          centerTitle: true,
        ),
        body: SmartRefresher(
          key: _refreshKey,
          controller: _refreshController,
          enablePullUp: true,
          physics: BouncingScrollPhysics(),
          footer: ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
          ),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: buildPaginationContent(),
        ),
      ),
      headerBuilder: () => WaterDropMaterialHeader(
        backgroundColor: Colors.red,
      ),
      footerTriggerDistance: 30.0,
    );
  }

  Widget buildPaginationContent() {
    return ListView.separated(
      itemCount: posts.length,
      itemBuilder: (_, index) {
        return Container(
          height: 70.0,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('${posts[index].id}  ${posts[index].title}'),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          height: 2,
          thickness: 2,
          color: Colors.grey,
        ),
      ),
    );
  }
}
