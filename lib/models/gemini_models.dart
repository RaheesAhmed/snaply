// Models for Gemini API requests and responses
class GeminiRequest {
  final List<Content> contents;
  final GenerationConfig generationConfig;
  final List<SafetySetting>? safetySettings;

  GeminiRequest({
    required this.contents,
    required this.generationConfig,
    this.safetySettings,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'contents': contents.map((content) => content.toJson()).toList(),
      'generationConfig': generationConfig.toJson(),
    };

    if (safetySettings != null && safetySettings!.isNotEmpty) {
      json['safetySettings'] =
          safetySettings!.map((setting) => setting.toJson()).toList();
    }

    return json;
  }
}

class Content {
  final List<Part> parts;
  final String? role;

  Content({
    required this.parts,
    this.role,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'parts': parts.map((part) => part.toJson()).toList(),
    };
    if (role != null) {
      json['role'] = role;
    }
    return json;
  }

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      parts: (json['parts'] as List)
          .map((e) => Part.fromJson(e as Map<String, dynamic>))
          .toList(),
      role: json['role'] as String?,
    );
  }
}

class Part {
  final String? text;
  final InlineData? inlineData;

  Part({
    this.text,
    this.inlineData,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (text != null) {
      json['text'] = text;
    }
    if (inlineData != null) {
      json['inlineData'] = inlineData!.toJson();
    }
    return json;
  }

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      text: json['text'] as String?,
      inlineData: json.containsKey('inlineData')
          ? InlineData.fromJson(json['inlineData'] as Map<String, dynamic>)
          : null,
    );
  }
}

class InlineData {
  final String mimeType;
  final String data;

  InlineData({
    required this.mimeType,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'mimeType': mimeType,
      'data': data,
    };
  }

  factory InlineData.fromJson(Map<String, dynamic> json) {
    return InlineData(
      mimeType: json['mimeType'] as String,
      data: json['data'] as String,
    );
  }
}

class GenerationConfig {
  final double temperature;
  final int topK;
  final double topP;
  final int maxOutputTokens;
  final List<String> responseModalities;

  GenerationConfig({
    this.temperature = 1.0,
    this.topK = 40,
    this.topP = 0.95,
    this.maxOutputTokens = 8192,
    this.responseModalities = const ['image', 'text'],
  });

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'topK': topK,
      'topP': topP,
      'maxOutputTokens': maxOutputTokens,
      'response_modalities': responseModalities,
    };
  }
}

class GeminiResponse {
  final List<Candidate> candidates;
  final UsageMetadata usageMetadata;
  final String modelVersion;

  GeminiResponse({
    required this.candidates,
    required this.usageMetadata,
    required this.modelVersion,
  });

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiResponse(
      candidates: (json['candidates'] as List)
          .map((e) => Candidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      usageMetadata:
          UsageMetadata.fromJson(json['usageMetadata'] as Map<String, dynamic>),
      modelVersion: json['modelVersion'] as String,
    );
  }
}

class Candidate {
  final Content content;
  final String finishReason;
  final int index;

  Candidate({
    required this.content,
    required this.finishReason,
    required this.index,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      finishReason: json['finishReason'] as String,
      index: json['index'] as int,
    );
  }
}

class UsageMetadata {
  final int promptTokenCount;
  final int totalTokenCount;
  final List<PromptTokenDetail> promptTokensDetails;

  UsageMetadata({
    required this.promptTokenCount,
    required this.totalTokenCount,
    required this.promptTokensDetails,
  });

  factory UsageMetadata.fromJson(Map<String, dynamic> json) {
    return UsageMetadata(
      promptTokenCount: json['promptTokenCount'] as int,
      totalTokenCount: json['totalTokenCount'] as int,
      promptTokensDetails: (json['promptTokensDetails'] as List)
          .map((e) => PromptTokenDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PromptTokenDetail {
  final String modality;
  final int tokenCount;

  PromptTokenDetail({
    required this.modality,
    required this.tokenCount,
  });

  factory PromptTokenDetail.fromJson(Map<String, dynamic> json) {
    return PromptTokenDetail(
      modality: json['modality'] as String,
      tokenCount: json['tokenCount'] as int,
    );
  }
}

/// Safety setting for Gemini API
class SafetySetting {
  final String category;
  final String threshold;

  SafetySetting({
    required this.category,
    required this.threshold,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'threshold': threshold,
    };
  }
}
