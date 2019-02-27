class Task < ApplicationRecord
  # 一つのタスクに一つの画像を紐付ける
  # :imageはファイルの呼び名
  has_one_attached :image
  before_validation :set_nameless_name
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  def self.csv_attributes
    # CSVデータにどの属性をどの順番で出力するかを定義
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    # CSV.generateを使ってCSVデータの文字列を生成する
    CSV.generate(headers: true) do |csv|
      # CSVの一行目としてヘッダを出力する
      csv << csv_attributes
      # allメソッドで全タスクを取得し、1レコードごとにCSVの1行目を出力する
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr) }
      end
    end
  end

  # fileという名前の引数で、アップロードされたファイルの内容にアクセスするためのオブジェクトを受け取る
  def self.import(file)
    # CSV.foreachを使ってCSVファイルを一行ずつ読み込む。headers: trueの指定により、1行目をヘッダとして無視するようにしている
    CSV.foreach(file.path, headers: true) do |row|
      # CSV一行ごとにTaskインスタンスを生成する（newはTask.newと同意）
      task = new
      # 生成されたTaskインスタンスの各属性にCSVの一行の情報を加工して入れ込む
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

  private

  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end

  def validate_name_not_including_comma
    # 名前にカンマが含まれていたら、errorsにエラー内容を格納する
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
