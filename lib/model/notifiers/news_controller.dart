import 'package:sharing_map/model/data/article.dart';
import 'package:sharing_map/model/services/news_service.dart';
import 'package:get/get.dart';

class NewsController extends GetxController {
  var articles = <Article>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticle();
  }

  void fetchArticle() async {
    isLoading(true);

    try {
      isLoading(true);
      var articleTemp = await NewsWebService.fetchNews();
      if (articleTemp != null) {
        articles(articleTemp);
      }
    } finally {
      isLoading(false);
    }
  }

  void onRefresh() async {
    fetchArticle();
  }

  void fetchQuery(String query) async {
    isLoading(true);

    try {
      isLoading(true);
      var articleTemp = await NewsWebService.fetchNewsQuery(query);
      if (articleTemp != null) {
        articles(articleTemp);
      }
    } finally {
      isLoading(false);
    }
  }
}
