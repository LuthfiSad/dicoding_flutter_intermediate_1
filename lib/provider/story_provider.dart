import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intermediate_flutter/api/api_service.dart';
import 'package:intermediate_flutter/local/preferences.dart';
import 'package:intermediate_flutter/model/detail_story.dart';
import 'package:intermediate_flutter/model/response/add_new_story_response.dart';
import 'package:intermediate_flutter/model/story.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Preferences _preferences = Preferences();

  final List<Story> _stories = [];
  late DetailStory _detailStory;
  int? pageItems = 1;
  int sizeItems = 12;
  XFile? _image;
  String? _imagePath;
  bool _isLoggingIn = false;
  bool _isFetching = false;
  bool storyNeedLocation = false;

  List<Story> get stories => _stories;
  DetailStory get detailStory => _detailStory;
  XFile? get image => _image;
  String? get imagePath => _imagePath;
  bool get isLoggingIn => _isLoggingIn;
  bool get isFetching => _isFetching;
  bool get isStoryNeedLocation => storyNeedLocation;

  StoryProvider() {
    initDetailStory();
    sortStories();
  }

  void sortStories() {
    _stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  void setIsFetching(bool isFetching) {
    _isFetching = isFetching;
    notifyListeners();
  }

  void setIsLoggingIn(bool isLoggingIn) {
    _isLoggingIn = isLoggingIn;
    notifyListeners();
  }

  void setStoryNeedLocation(bool value) {
    _stories.clear();
    pageItems = 1;
    storyNeedLocation = value;
    getAllStories();
    notifyListeners();
  }

  void initDetailStory() {
    _detailStory = DetailStory(
      id: '',
      name: '',
      description: '',
      photoUrl: 'abc',
      createdAt: DateTime.now(),
      lat: 0,
      lon: 0,
    );
    notifyListeners();
  }

  void setImage(XFile value) {
    _image = value;
    notifyListeners();
  }

  void setImagePath(String value) {
    _imagePath = value;
    notifyListeners();
  }

  void deleteImage() {
    _image = null;
    _imagePath = null;
    notifyListeners();
  }

  Future<List<Story>> getAllStories() async {
    setIsFetching(true);
    final userToken = await _preferences.getUserToken();
    final response = await _apiService.getAllStories(
      userToken,
      pageItems!,
      sizeItems,
      storyNeedLocation ? 1 : 0,
    );
    notifyListeners();

    if (response.error == false) {
      if (response.listStory.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }
      notifyListeners();
      setIsFetching(false);
      _stories.addAll(response.listStory);
      sortStories();
      notifyListeners();
      return _stories;
    }

    setIsFetching(false);
    return _stories;
  }

  Future<DetailStory> getDetailStories(String id) async {
    setIsFetching(true);
    final userToken = await _preferences.getUserToken();
    final response = await _apiService.getDetailStory(id, userToken);

    if (response.error == false) {
      setIsFetching(false);
      _detailStory = response.story;
      notifyListeners();
      return _detailStory;
    }

    setIsFetching(false);
    return _detailStory;
  }

  Future<AddNewStoryRepsonse> addNewStory(
    String description,
    String errorMesssage,
    double lat,
    double lon,
  ) async {
    setIsFetching(true);
    final userToken = await _preferences.getUserToken();

    if (_image == null) {
      // throw alert error

      return AddNewStoryRepsonse.failure(errorMesssage);
    }

    final fileName = _image!.name;
    final bytes = await _image!.readAsBytes();

    var response = await _apiService.addNewStory(
      description,
      bytes,
      fileName,
      userToken!,
      lat,
      lon,
    );

    if (response.error == false) {
      // this is for refresh the list then fetch new data
      _stories.clear();
      pageItems = 1;
      getAllStories();
      notifyListeners();
      setIsFetching(false);
      return AddNewStoryRepsonse.success();
    }

    setIsFetching(false);
    return AddNewStoryRepsonse.failure(response.message);
  }

  void onGalleryView() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) {
      // throw alert error

      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      notifyListeners();

      if (pickedFile != null) {
        setImage(pickedFile);
        setImagePath(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      return;
    }
  }

  void onCameraView() async {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) {
      // throw alert error

      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
      notifyListeners();

      if (pickedFile != null) {
        setImage(pickedFile);
        setImagePath(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      // throw alert error
      return;
    }
  }
}
