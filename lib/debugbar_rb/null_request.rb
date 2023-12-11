class NullRequest
  private def method_missing(symbol, *args)
    nil
  end
end
