//
//  ArticleAnalyserService.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import Foundation
import SwiftUI
import SwiftSoup
import NaturalLanguage

enum AnalyserError: Error {
  case badURL
  case downloadFailed
  case textExtractionFailed(_ error: Error)
}

protocol ArticleAnalyser {
  // fetch the article and return the entire HTML text
  func fetchArticle(from url: String, completion: @escaping (Result<String, AnalyserError>) -> Void)
  
  // extract just the body of the web page
  func extractText(from html: String, completion: @escaping (Result<String, AnalyserError>) -> Void)
  
  // extract the title
  func extractTitle(from html: String, completion: @escaping (Result<String, AnalyserError>) -> Void)
  
  // analyse the text and return the tags we inferred
  func inferTags(from text: String, completion: ([Tag]) -> Void)
  
  // fetch an image for the given tags
  func fetchImage(for tags: [Tag], completion: (Image) -> Void)
}

extension ArticleAnalyser {
  func process(url: String, completion: @escaping (Article) -> Void) {
    self.fetchArticle(from: url) { result in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let html):
        self.extractTitle(from: html) { result in
          switch result {
          case .failure(let error):
            print(error.localizedDescription)
          case .success(let title):
            self.extractText(from: html) { result in
              switch result {
              case .failure(let error):
                print(error.localizedDescription)
              case .success(let text):
                self.inferTags(from: text) { tags in
                  let article = Article(url: url, title: title, tags: tags)
                  completion(article)
                }
              }
            }
          }
        }
      }
    }
  }
}