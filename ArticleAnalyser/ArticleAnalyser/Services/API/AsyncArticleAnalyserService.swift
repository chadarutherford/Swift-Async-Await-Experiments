//
//  AsyncArticleAnalyserService.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 03.02.21.
//

import Foundation
import SwiftUI

protocol AsyncArticleAnalyser {
  // fetch the article and return the entire HTML text
  func fetchArticle(from url: String) async throws -> String
  
  // extract just the body of the web page
  func extractText(from html: String) async throws -> String
  
  // extract the title
  func extractTitle(from html: String) async throws -> String
  
  // analyse the text and return the tags we inferred
  func inferTags(from text: String) async -> [Tag]
  
  // try to extract image meta tag
  func extractImage(from url: String) async throws -> String
}

extension AsyncArticleAnalyser {
  func process(url: String) async throws -> Article {
    let htmlText = try await fetchArticle(from: url)
    let text = try await extractText(from: htmlText)
    let title = try await extractTitle(from: htmlText)
    let imageUrl = try await extractImage(from: url)
    let tags = await inferTags(from: text)
    
    return Article(url: url,
                   title: title,
                   tags: tags,
                   imageUrlString: imageUrl)
  }
}






